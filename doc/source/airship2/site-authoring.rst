.. _site_authoring_guide:

Site Authoring Guide
====================

This guide describes the steps to create the site documents needed by Airship
to deploy a standard greenfield bare metal deployment according to your
specific environment. In the form of YAML comments, the ``reference-airship-core``
site manifests in the Treasuremap git repository contain the tags and
descriptions of the required site specific information that the users must
provide.

Airship Layering Approach
~~~~~~~~~~~~~~~~~~~~~~~~~

Following the DRY (Don't Repeat Yourself) principle, Airship uses four
conceptual layer types to drive consistency and reusability:

* Function: An atomic, independent building block of a Kubernetes workload,
  e.g., a HelmRelease, Calico.
* Composite: A logical group of multiple Functions integrated and configured
  for a common purpose. Typical examples include OpenStack or interrelated
  logging and monitoring components.  Composites can also pull in other
  Composites to further customize their configurations.
* Type: A prototypical deployment plan that represents a typical user case,
  e.g., network cloud, CI/CD pipeline, basic K8S deployment. A Type defines
  the collection of Composites into a deployable stack, including control
  plane, workload, and host definitions. A Type also defines the Phases of
  deployment, which serve to sequence a deployment (or upgrade) into
  stages that must be performed sequentially, e.g., the Kubernetes cluster
  must be created before a software workload is deployed. A type can inherit
  from another type.
* Site: A Site is a realization of exactly one Type, and defines (only) the
  site-specific configurations necessary to deploy the Type to a specific
  place.

To learn more about the Airship layering design and mechanism, it is highly
recommended to read :ref:`layering-and-deduplication`.

.. _init_site:

Initializing New Site
~~~~~~~~~~~~~~~~~~~~~

It is a very complex and tedious task to create a new site form scratch.
Therefore, it is strongly recommended that the user creates the new site based
on a reference site. The reference site can be a site that has been already
created and deployed by the user, or an example site in the treasuremap git
repository.

The `reference-airship-core`_ site from the treasuremap may be used for such
purpose. It is the principal pipeline for integration and continuous deployment
testing of Airship on bare metal.

To create a new site definition from the ``reference-airship-core`` site, the
following steps are required:

1. Clone the ``treasuremap`` repository at the specified reference in the Airship
   home directory.
2. Create a project side-by-side with ``airshipctl`` and ``treasuremap`` directory.
3. Copy the reference site manifests to ${PROJECT}/manifests/site/${SITE}.
4. Update the site's metadata.yaml appropriately.
5. Create and update the Airship config file for the site in
   ``${HOME}/.airship/config``.

Airshipctl provides a tool ``init_site.sh`` that automates the above site creation
tasks.

.. code-block:: bash

   export AIRSHIPCTL_REF_TYPE=tag # type can be "tag", "branch" or "commithash"
   export AIRSHIPCTL_REF=v2.0.0 # update with the git ref you want to use
   export TREASUREMAP_REF_TYPE=tag # type can be "tag", "branch" or "commithash"
   export TREASUREMAP_REF=v2.0.0 # update with the git ref you want to use
   export REFERENCE_SITE=../treasuremap/manifests/site/reference-airship-core
   export REFERENCE_TYPE=airship-core # the manifest type the reference site uses

   ./tools/init_site.sh

.. note::
   The environment variables have default values that point to arishipctl
   release tag v2.0.0 and treasuremap release tag v2.0.0. You only need
   to (re)set them in the command line if you want a different release
   version, a branch or a specific commit.

   To find the Airship release versions and tags, go to :ref:`versioning`. In
   addition to release tag, the user can also specify a branch (e.g., v2.0)
   or a specific commit ID when checking out the ``treasuremap`` or ``airshipctl``
   repository.

.. _reference-airship-core:
   https://github.com/airshipit/treasuremap/tree/v2.0/manifests/site/reference-airship-core

Preparing Deployment Documents
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After the new site manifests are initialized, you will then need to manually
make changes to these files. These site manifests are heavily commented to
identify and explain the parameters that need to change when authoring a new
site.

The areas that must be updated for a new site are flagged with the label
``NEWSITE_CHANGEME`` in YAML comments. Search for all instances of
``NEWSITE_CHANGEME`` in your new site definition. Then follow the instructions
that accompany the tag in order to make all needed changes to author your new
Airship site.

Because some files depend on (or may repeat) information from others,
the order in which you should build your site files is as follows.

.. note::

   A helpful practice is to replace the tag ``NEWSITE_CHANGEME`` with
   ``NEWSITE_CHANGED`` along the way when each site specific value is entered.
   You can run a global search on ``NEWSITE_CHANGEME`` at the end to check if
   any site fields were missed.

Network
+++++++

Before you start, collect the following network information:

   * PXE network interface name
   * The name of the two 25G networks used for the bonded interface
   * OAM, Calico and Storage VLAN ID's
   * OAM, Calico and Storage netowrk configuration
   * PXE, OAM, Calico and Storage IP addresses for ephemeral/controller nodes
     and worker nodes
   * Kubernetes and ingress virtual IP address (on OAM)
   * DNS servers
   * NTP servers

First, define the target and ephemeral networking catalogues.

   * ``manifests/site/${SITE}/target/catalogues/networking.yaml``:
     Contains the network definition in the entire system.
   * ``manifests/site/${SITE}/target/catalogues/networking-ha.yaml``:
     Defines the Kubernetes and ingress virtual IP addresses as well as the
     OAM interface.
   * ``manifests/site/${SITE}/ephemeral/catalogues/networking.yaml``:
     Provides only the overrides specific to the ephemeral nodes.

Last, update network references (e.g., interface name, IP address, port) in
the target cluster deployment documents:

   * ``manifests/site/${SITE}/phases/phase-patch.yaml``
   * ``manifests/site/${SITE}/target/catalogues/versions-airshipctl.yaml``
   * ``manifests/site/${SITE}/target/controlplane/metal3machinetemplate.yaml``
   * ``manifests/site/${SITE}/target/controlplane/versions-catalogue-patch.yaml``
   * ``manifests/site/${SITE}/target/initinfra-networking/patch_calico.yaml``
   * ``manifests/site/${SITE}/target/workers/provision/metal3machinetemplate.yaml``
   * ``manifests/site/${SITE}/kubeconfig/kubeconfig.yaml``

Host Inventory
++++++++++++++

Host inventory configuration requires the following information for each server:

   * host name
   * BMC address
   * BMC user and password
   * PXE NIC mac address
   * OAM | Calico | PXE | storage IP addresses

Update the host inventory and other ephemeral and target cluster documents:

   * ``manifests/site/${SITE}/host-inventory/hostgenerator/host-generation.yaml``:
     Lists the host names of the all the nodes in the host inventory.
   * ``manifests/site/${SITE}/target/catalogues/hosts.yaml``: The host catalogue
     defines the host information such as BMC address, credential, PXE NIC, IP
     addresses, hardware profile name, etc., for every single host.
   * ``manifests/site/${SITE}/ephemeral/bootstrap/baremetalhost.yaml``:
     Contains the host name and bmc address of the ephemeral bare metal host.
   * ``manifests/site/${SITE}/ephemeral/bootstrap/hostgenerator/host-generation.yaml``:
     Defines the single host in the ephemeral cluster.
   * ``manifests/site/${SITE}/ephemeral/controlplane/hostgenerator/host-generation.yaml``:
     Defines the host name of the first controller node to bootstrap ion the
     target cluster.
   * ``manifests/site/${SITE}/phases/phase-patch.yaml``: Updates the ephemeral
     node host name and ISO URL.
   * ``manifests/site/${SITE}/target/controlplane/hostgenerator/host-generation.yaml``:
     Defines the list of hosts to be deployed in the target cluster.
   * ``manifests/site/${SITE}/target/workers/hostgenerator/host-generation.yaml``:
     Defines the list of hosts of the worker nodes.
   * ``manifests/site/air-pod01/target/workers/provision/machinedeployment.yaml``:
     Configures the total number of worker nodes

Downstream Images and Binaries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For a production environment, the access to external resources such as the
``quay.io`` or various ``go`` packages may not be available, or further customized
security hardening is required in the images.

In those cases, the operator will need to host their pre-built images or
binaries in a downstream repository or artifactory. The manifests specifying
image locations for the Kustomize plugins will need to be updated prior to
running airshipctl commands, e.g., replacement-transformer, templater, sops,
etc.

Here is an example ``sed`` command on the cloned airshipctl and treasuremap
manifests for updating the image locations:

.. code-block:: bash

 find ./airshipctl/manifests/ ./treasuremap/manifests/ -name "*.yaml" -type f -readable -writable -exec sed -i \
   -e "s,gcr.io/kpt-fn-contrib/sops:v0.1.0,docker-artifacts.my-telco.com/upstream-local/kpt-fn-contrib/sops:v0.1.0,g" -i \
   -e "s,quay.io/airshipit/templater:latest,docker-artifacts.my-telco.com/upstream-local/airshipit/templater:latest,g" -i \
   -e "s,quay.io/airshipit/replacement-transformer:latest,docker-artifacts.my-telco.com.com/upstream-local/airshipit/replacement-transformer:latest,g" {} +;

Now the manifests for the new site are ready for deployment.
