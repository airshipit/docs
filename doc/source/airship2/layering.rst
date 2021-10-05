..
      Licensed under the Apache License, Version 2.0 (the "License"); you may
      not use this file except in compliance with the License. You may obtain
      a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
      WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
      License for the specific language governing permissions and limitations
      under the License.

.. _layering-and-deduplication:

Layering and Deduplication
==========================

Airship Layering Structure
--------------------------

Airship addresses the DRY (Don't Repeat Yourself) principle by promoting
the use of conceptual "layers" of declarative intent.  Some configuration
is completely generic and reusable - for example, the basic Pod,
Deployment, and HelmRelease resources that make up a Kubernetes
application deployment.  Other information will be fully site-specific -
e.g., the IP addresses and hostnames unique to a site.  The site-specific
information typically needs to be injected into the generic resources,
which can be conceptualized as overlaying the site-specific layer
on top of the generic, reusable base.  Although any number of layers could
be applied in arbitrary ways, Airship has chosen the following conceptual
layer types to drive consistency and reusability:

* Functions:  basic, independent building blocks of a Kubernetes workload.
  Typical examples include a single HelmRelease or an SDN.
* Composites:  Integrations of multiple Functions, integrating/configuring
  them for a common purpose.  Typical examples include OpenStack or
  interrelated logging and monitoring components.  Composites can also
  pull in other composites to further customize their contents.
* Types:  Prototypical deployment plans.  A Type defines composites
  into a deployable stack, including control plane, workload, and
  host definition functions. A Type will define Phases of deployment,
  which serve to sequence a deployment (or upgrade) into stages that
  must be performed sequentially - e.g., the Kubernetes cluster must
  be created before a software workload is deployed into it.
  A type can pull in any number of Composites, and when appropriate
  can inherit from exactly one other Type.
  Types typically represent "use cases" such as a Network Cloud, a
  CI/CD system, or a basic Kubernetes deployment.
* Sites:  A Site is a realization of exactly one Type, and defines (only) the
  site-specific configuration necessary to deploy the Type to a
  specific place.

The layers above are simply conventions.  In practice, each layer is represented
by a Kustomization (see `Kustomize Overview`_ below),
and relationships between layers are captured by a
``kustomization.yaml`` referencing an external Kustomization.  Additionally,
Airship layers may refer to layers in other code repositories, and Airship
will ensure all required projects are present and in expected locations relative
to a site definition.  This allows for operator-specific (upstream or downstream)
repositories to inherit and reuse the bulk of declarative intent from
common, upstream sources; e.g. the Airship Treasuremap_ project.
By convention, Airship manifests can be found in a project's
``manifests/`` folder, further categorized by the layer type -- e.g.,
``manifests/function/my-chart`` or ``manifests/site/my-site``.

TODO: add pictures

The fundamental mechanism that Kustomize provides for layering is "patching",
which operates on a specific YAML resource and changes individual elements
or full YAML subtrees within the resources.  Kustomize supports both
JSON patching and Strategic Merge patching; see `Kustomize Patching`_
for more details.

Kustomize Overview
------------------

Airship uses the Kustomize_ tool to help organize, reuse, and deduplicate
declarative intent.  Kustomize has widespread usage in the Kubernetes
community, and provides a standalone command-line interface that lets a user
start with "generic" manifests in one location, and then apply overrides
from a different location.  This can be used to perform operator- or
site-specific customization (hence the name) of resource namespaces,
patches against arbitrary YAML keys, and many other features.

Kustomize also provides a Go library interface to drive its functionality,
which is used by projects such as ``kubectl``, ``kpt``, and ``airshipctl``.
Airshipctl incorporates Kustomize into its higher-order functionality, so
that it's invoked as part of ``airshipctl phase run``, rendering
manifests into a deployable form before deploying them directly to a
Kubernetes apiserver.  However, Airship follows the design decision for
its YAMLs to be fully renderable using the stock ``kustomize`` command.

The basic building block for Kustomize manifests is called a "kustomization",
which typically consists of a directory folder containing Kubernetes
resources, patches against them, and other information; and the file
``kustomization.yaml``, which acts as a roadmap to Kustomize on what
to do with them.  A ``kustomization.yaml`` can also point out to other
kustomization directories (each with their own ``kustomization.yaml``) to pull
them in as base resources, resulting in a tree structure.  In an Airship
context, the root of the tree would represent an Airship deployment phase,
and the leaves would be functions that capture something fine-grained, like
a HelmRelease chart resource.

Plugins
-------

Airship extends Kustomize via plugins to perform certain activities which
must be done in the middle of rendering documents (as opposed to before
or after rendering). The plugins are implemented as containerized
"KRM Functions", a standard which originated in the KPT project community.
Kustomize invokes these plugins to create or modify
YAML resources when instructed to via ``kustomization.yaml``.
The KRM Functions that are leveraged by airshipctl include:

ReplacementTransformer
^^^^^^^^^^^^^^^^^^^^^^

Kustomize is very good at layering patches on top of resources, but has
some weakness when performing substitution/replacement type operations,
i.e., taking information from one document and injecting it into another
document.  This operation is very critical to Airship from a de-duplication
perspective, since the same information (e.g. a Kubernetes version or
some networking information) would be needed in multiple resources.
Replacement helps satisfy the DRY principle.  Although Kustomize has a few
flavors of variable replacement-type functionality, a plugin
was required to consistently support simple replacement, injection of
YAML trees into arbitrary paths of a target document, and substring replacement.

Airship's ReplacementTransformer function is based on the example plugin
of the same name from the Kustomize project, and extends it with substring
replacement, improved error handling, and other functionality.

The ReplacementTransformer is invoked by Kustomize when a transformer
plugin configuration with ``kind: ReplacementTransformer`` and
``apiVersion: airshipit.org/v1alpha1`` is referenced in a
``kustomization.yaml``.  The plugin configuration payload contains
a list of replacement instructions, each with "source" and "destination"
definitions.

See the `Replacement Transformer`_ documentation for examples and usage.

Templater
^^^^^^^^^

While ReplacementTransformer modifies existing resources, the Templater
is a Kustomize "generator" plugin that creates brand new resources based
on a Go Template.  This is helpful when you have a number of resources
that are nearly identical, and allows the common parts to be
de-duplicated into a template.  An example of this would be resources
that are specific per-host (like Metal3 ``BareMetalHost``).

The ReplacementTransformer and Templater can also be combined in a chain,
with the ReplacementTransformer injecting information into a Templater
plugin configuration (for example, the number and configuration of
``BareMetalHost`` resources to generate), so that it has all of the information
it needs to generate resources for a particular site.

See the `Templater`_ documentation for examples and usage.

Encryption, Decryption, and Secret Generation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Encryption and decryption is handled via the `sops` KRM Function maintained
by the KPT community.  This function in turn uses the Mozilla SOPS tool
to perform asymmetric key-based decryption on encrypted values within
YAML resources.  

In addition, passwords, keys, and other sensitive secrets can be generated
from scratch on a site-by-site basis.  This helps ensure that secrets are
properly randomized and are unique to particular deployments.  This process
uses the Templater function to describe what secrets should be generated,
and the SOPS plugin to encrypt them immediately, before being written
to disk.

See the `Secrets generation and encryption` guide for examples and usage.

Replacement
-----------

The resource patching functionality that Kustomize provides out-of-box
solves for many config deduplication needs, particularly when an operator
wants to define some override YAML and then apply it on top of exactly
one resource.  However, it does not solve for the case where some piece
of configuration, e.g. a Kubernetes version number, needs to be applied
against multiple resources that need it.  Using patches alone, this would
result in duplicating the same version number defined in multiple patches
within the same layer, increasing both maintenance effort and opportunity
for human error.  To address this, Airship uses the ReplacementTransformer
plugin described above.

The ReplacementTransformer can inject individual YAML elements or trees
of YAML structure into a specific path of a target resource.  The source
for the injected YAML can come from any arbitrary resource.  For the sake of
maintainability and readability, Airship uses "variable catalogue" resources
as replacement sources.  These catalogues group related configuration
together with an expected document name and YAML structure, and their
sole purpose is to serve as a replacement source.  Today, these catalogues
are a mix of free-form ``kind: VariableCatalogue``, and well-schema'd
per-catalogue kinds.  The plan is to migrate all of them to well-defined
schemas over time.

In general, Airship defines three things: good default configuration
at the Function level, default/example catalogues that also contain
(typically the same) default values, and ReplacementTransformer
configuration that copies data from one to the other.  This conforms to
the Kustomize philosophy of base resources being "complete" in and of
themselves.  In practice, we encourage operators to supply their own
catalogues, rather than basing on the upstream default/example catalogues.

Versions Catalogues
^^^^^^^^^^^^^^^^^^^

Software versioning is frequently an example of information that should
be defined once, and be consumed in multiple locations.  However, a
more compelling reason to pool versioning information together into
a single source catalogue, even when it will be consumed by exactly
one target document, is simply to put it all in the same place.
Versioning information also includes definition of registries
and repositories, so by defining all of your versions in one place,
it becomes more straight forward to change them all at once.
For example, an operator may choose to pull all Docker containers from
a downstream container registry instead of the default upstream registry.
Another example would be upgrading the versions of a number of
interrelated software components at the same time (e.g. a new OpenStack
release).  On the other hand, a monolithic versions catalog would run the
risk of coupling unrelated software components together.

Airship balances these concerns by typically defining one versions catalogue
per manifest repository (e.g. ``airshipctl``, ``treasuremap``,
``openstack-helm``), with a naming convention of ``versions-<repo-name>``.
This keeps the definition of default versions close to the Functions that define
them and the Composites that integrate them, and avoids cross-repo dependency
concerns.  Within their home repository, the base catalogue should live in
a standalone Function (called something like ``catalogues-<repo-name>``, so
that it can easily be swapped out for alternate version definitions.
The per-repository catalogues all share the ``kind: VersionsCatalogue``
schema, which is defined in the ``airshipctl`` repository.

The definition of the replacement "rules", captured in the
ReplacementTransformer plugin configuration, will typically be done at the
Composite level as part of the integration work for which they're responsible.
Those Composites should each feature a README that details any catalogues
needed to render them.

Note that versioning for Cluster API (CAPI_) providers will be handled slightly
differently, for a couple reasons:

1. CAPI provider versions are a part of the directory structure (e.g.
   ``manifests/function/capm3/v0.3.1/``, which are also closely coupled to
   airshipctl itself.  So, versioning of CAPI components is out-of-scope
   for a catalogue-driven perspective, and is left to the airshipctl project.
2. CAPI container versions/locations must be handled differently, because
   those resources are not pulled in via the same phase-driven approach
   as everything else, and are instead referenced indirectly via a
   ``Clusterctl`` resource (which is a normal, phase-included resource).
   Since this ``Clusterctl`` config can pass variables into the clusterctl
   rendering process, the solution will be: first, use the
   ReplacementTransformer plugin to substitute container versions from the
   ``versions-airshipctl`` catalogue into the ``Clusterctl`` resource;
   then, let clusterctl itself push those values into the appropriate
   CAPI resources via its variable replacement functionality.
3. To perform upgrades of CAPI components, two sets of versions, the old
   and the new, will need to be substituted into the ``Clusterctl``
   resource simultaneously.  Therefore, their version catalogue will need to
   contain multiple sets of container versions, using the provider version
   number as part of the YAML path (just like it's part of the directory
   path above).

Similarly to container versioning, ``HelmRelease`` resources will refer
out to Helm charts by location and version.  This is still being defined
as of this writing, but in production use cases at least, Airship will use
a "Helm Collator" that will cache built charts in a single container image
and then serve the charts within the cluster.  We may also support deploying
charts dynamically from github (as in Airship 1) if the Helm Controller
continues to support that feature.  In any case, the plan is for the
chart locations/versions to be encoded in a versions catalogue(s), and for
that to drive the collator build process and/or live chart rendering.

Note that the trigger gets pulled on replacement only at the Site/Phase level;
one can apply patches to catalogues till then.  For example, if a catalogue
is defined at the Type level with normal default values, the values
can be overridden in the catalogue resource at the Site level before the
catalogue is actually used.

TODO: include a lifecycle diagram that shows documents and replacements
getting aggregated, and then ultimately executed at site level.

Note that Kubernetes resource versions are a different animal, and are not
addressed via catalogue replacement.


Host Catalogue and Host Generation Catalogue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO

Network Catalogue
^^^^^^^^^^^^^^^^^

Networking is another example of a set of values that all change at once:
on an operator-by-operator basis (for shared network services like DNS),
and on a site-by-site basis (for subnet IP address ranges).
This information is extracted into a VariableCatalogue with
``name: networks``.  Individual functions that consume the information will
provide their own replacement rules to do so.

A default/example set of values is defined in the ``airshipctl-catalogues``
function, and it can be patched (or duplicated) at the Type or Site levels to
apply operator- and site-specific information, respectively.

Note that per-host IP addresses are generally specified in the Host Catalogue
rather than the Network Catalogue.

Today, the Network Catalogue is specific to Functions in the ``airshipctl``
repository, which defines a ``kind: NetworkCatalogue`` schema for it.

Endpoint Catalogues
^^^^^^^^^^^^^^^^^^^

For internal cluster endpoints that are expected to be generally the same
between use cases, operator-specific types, and sites, there may be no need
to externalize the endpoint into the catalogue.  In those cases, an operator
may still choose override the endpoint via a Kustomize patch.

TODO

Phases
------

TODO

Treasuremap
-----------

TODO

.. _CAPI: https://github.com/kubernetes-sigs/cluster-api
.. _Kustomize: https://kubernetes-sigs.github.io/kustomize/
.. _Kustomize Patching: https://github.com/kubernetes-sigs/kustomize/blob/master/examples/patchMultipleObjects.md
.. _Replacement Transformer: https://github.com/airshipit/airshipctl/tree/master/krm-functions/replacement-transformer
.. _Secrets generation and encryption: https://github.com/airshipit/airshipctl/blob/master/docs/source/secrets-guidelines.md
.. _Templater: https://github.com/airshipit/airshipctl/tree/master/krm-functions/templater
.. _Treasuremap: https://opendev.org/airship/treasuremap
