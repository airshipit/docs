..
      Copyright 2020-2021 The Airship authors.
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

Release Notes
=============

Airship Overview
----------------

Airship is a robust system for delivering container-based cloud infrastructure
(or any other containerized workload)
at scale on bare metal, public clouds, and edge clouds.
Airship integrates best-of-class CNCF projects, such as Cluster API, Kustomize, Metal3,
and Helm Operator, to deliver a resilient and predictable lifecycle experience.

Combining easy lifecycle management with zero-downtime real-time upgrade capability,
Airship can handle the
provisioning and configuration of the operating system, RAID services, and the network.

Airship 2.1 (30 November 2021)
------------------------------

Release 2.1 introduces the following enhancements:
- Upgrade components to parity with Cluster API v1alpha4, including Bare Metal Operator v1alpha5
- Kubernetes upgrade to version 1.21
- Docker provider upgrade to v1alpha3
- CAPD and CAPZ upgrades to versions 0.4.2 and 0.5.2, respectively
- Airship in a Pod hardening and improvements such as support for custom site manifest locations and private repositories. (`477`_)
- Helm Controller upgrade to version 0.11.1 and Source Controller to version 0.15.3 (`607`_)
- Kustomize upgrade to version 4.2.0
- KPT upgrade to to version 1.0.0-beta.7
- Support of iLO5 in bare metal node bootstrapping

.. _477: https://github.com/airshipit/airshipctl/issues/477
.. _607: https://github.com/airshipit/airshipctl/issues/607

Airship 2.0 (16 April 2021)
---------------------------

Release 2.0 introduces a variety of significant improvements:
-  No-touch bootstrap for remote sites as well as local sites
-  Declarative image building for both ephemeral ISO and bare metal targeted QCOWs
-  Declarative cluster lifecycle
-  Lifecycle for bare metal, public cloud, and edge cloud infrastructure
-  Single command line "airshipctl"
-  Lifecycle defined as a sequence of phases
-  Introduction of a plan for the phases
-  Seamless integration with CNCF projects (CAPI, Metal3, Kustomize)
-  Seamless integration with security plugins like SOPS
-  Generic container interface: mechanism to extend airshipctl with ad hoc functionality
-  Introduction of host config operator for day 2 operations

Change Log
----------

Change logs list feature and defect details for a release.
For the complete set of releases including links to change logs,
see the `treasuremap`_ and `airshipctl`_ Github release pages.

.. _treasuremap: https://github.com/airshipit/treasuremap/releases/
.. _airshipctl: https://github.com/airshipit/airshipctl/releases/
