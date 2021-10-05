..
      Copyright 2019 AT&T Intellectual Property.
      All Rights Reserved.

      Licensed under the Apache License, Version 2.0 (the "License"); you may
      not use this file except in compliance with the License. You may obtain
      a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
      WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
      License for the specific language governing permissions and limitations
      under the License.

.. _crd-conventions:

CRD Conventions
===============

Airship will use CRDs to enrich the Kubernetes API with Airship-specific
document schema. Airship projects will follow the following conventions
when defining Custom Resource Definitions (CRDs).

Note that Airship integrates and consumes a number of projects from
other open source communities, which may have their own style conventions,
and which will therefore be reflected in Airship deployment manifests.
Those fall outside the scope of these Airship guidelines.

In general, Airship will follow the
`Kubernetes API Conventions`_ when defining CRDs.  These cover naming
conventions (such as using camelCase for key names),
expected document structure, HTTP request verbs and status codes,
and behavioral norms.

Exceptions or restrictions from the Kubernetes conventions are specified below;
this list may grow in the future.

*  The ``apiGroup`` (and ``apiVersion``) for Airship CRDs will have values
   following the convention ``<function>.airshipit.org``.

.. _Kubernetes API Conventions: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md
