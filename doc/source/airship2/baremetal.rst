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

Deploying A Bare Metal Cluster
==============================

The instructions for standing up a greenfield bare metal site can be broken
down into three high-level activities:

1. :ref:`site_setup_guide`: Contains the hardware and network
   requirement and configuration, and the instructions to set up the build
   environment.
2. :ref:`site_authoring_guide`: Describes how to craft site manifests and configs
   required for a site deployment performed by Airship.
3. :ref:`site_deployment_guide`: Describes how to deploy the site utilizing the
   manifests created as per the :ref:`site_authoring_guide`.

.. toctree::
   :hidden:
   :maxdepth: 1

   site-setup.rst
   site-authoring.rst
   site-deployment.rst

Support
-------

Bugs may be viewed and reported using GitHub issues for specific projects in
`Airship group <https://github.com/airshipit>`__:

   -  `Airship airshipctl <https://github.com/airshipit/airshipctl/issues>`__
   -  `Airship charts <https://github.com/airshipit/charts/issues>`__
   -  `Airship hostconfig-operator <https://github.com/airshipit/hostconfig-operator/issues>`__
   -  `Airship images <https://github.com/airshipit/images/issues>`__
   -  `Airship sip <https://github.com/airshipit/sip/issues>`__
   -  `Airship treasuremap <https://github.com/airshipit/treasuremap/issues>`__
   -  `Airship vino <https://github.com/airshipit/vino/issues>`__

Terminology
-----------

Please refer to :ref:`glossary` for the terminology used in this
document.

.. _versioning:

Versioning
----------

This document requires Airship Treasuremap and Airshipctl release version
v2.0.0 or newer.

Airship Treasuremap reference manifests are delivered periodically as release
tags in the `Treasuremap Releases`_.

Airshipctl manifests can be found as release tags in the `Airshipctl Releases`_.

.. _Airshipctl Releases: https://github.com/airshipit/airshipctl/releases
.. _Treasuremap Releases: https://github.com/airshipit/treasuremap/releases

.. note:: The releases are verified by `Airship in Baremetal Environment`_, and
  `Airship in Virtualized Environment`_ pipelines before delivery and are
  recommended for deployments instead of using the master branch directly.

.. _Airship in Baremetal Environment:
    https://jenkins.nc.opensource.att.com/job/Deployment/job/STL3-Baremetal_Deployment
.. _Airship in Virtualized Environment:
    https://jenkins.nc.opensource.att.com/job/development/job/AirshipCtl/job/Airshipctl
