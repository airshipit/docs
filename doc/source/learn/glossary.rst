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

.. _glossary:

Airship Glossary of Terms
=========================

.. If you add new entries, keep the alphabetical sorting!

.. glossary::

 Airship
  A platform that integrates a collection of best-of-class, interoperable and
  loosely coupled CNCF projects such as Cluster API, Kustomize, Metal3, and
  Helm Operator. The goal of Airship is to deliver automated and resilient
  container-based cloud infrastructure provisioning at scale on both bare
  metal and public cloud, and life cycle management experience in a completely
  declarative and predictable way.


 Bare metal provisioning
  The process of installing a specified operating system (OS) on bare metal
  host hardware. Building on open source bare metal provisioning tools such as
  OpenStack Ironic, Metal3.io provides a Kubernetes native API for managing
  bare metal hosts and integrates with the Cluster-API as an infrastructure
  provider for Cluster-API Machine objects.

 Cloud
  A platform that provides a standard set of interfaces for `IaaS <https://en.wikipedia.org/wiki/Infrastructure_as_a_service>`_ consumers.

 Container orchestration platform
  Set of tools that any organization that operates at scale will need.

 Control Plane
  From the point of view of the cloud service provider, the control plane
  refers to the set of resources (hardware, network, storage, etc.)
  configured to provide cloud services for customers.

 Data Plane
  From the point of view of the cloud service provider, the data plane is
  the set of resources (hardware, network, storage, etc.) configured to run
  consumer workloads. When used in Airship deployment, "data plane" refers
  to the data plane of the tenant clusters.

 Executor
  A usable executor is a combination of an executor YAML definition as well as
  an executor implementation that adheres to the ``Executor`` interface. A
  phase uses an executor by referencing the definition. The executor purpose
  is to do something useful with the rendered document set. Built-in executors
  include `KubernetesApply`_, `GenericContainer`_, `Clusterctl`_, and several
  other executors that helps with driving Redfish, bare metal node image
  creation.

 Hardware Profile
  A hardware profile is a standard way of configuring a bare metal server,
  including RAID configuration and BIOS settings. An example hardware profile
  can be found in the `Airshipctl repository`_.

 Helm
  `Helm`_ is a package manager for Kubernetes. Helm Charts help you define,
  install, and upgrade Kubernetes applications.

 Kubernetes
  An open-source container-orchestration system for automating application
  deployment, scaling, and management.

 Lifecycle management
  The process of managing the entire lifecycle of a product from inception,
  through engineering design and manufacture, to service and disposal of
  manufactured products.

 Network function virtualization infrastructure (NFVi)
  Network architecture concept that uses the technologies of IT virtualization
  to virtualize entire classes of network node functions into building blocks
  that may connect, or chain together, to create communication services.

 Openstack Ironic (OpenStack bare metal provisioning)
  An integrated OpenStack program which aims to provision bare metal machines
  instead of virtual machines, forked from the Nova bare metal driver.

 Orchestration
  Automated configuration, coordination, and management of computer systems and
  software.

 Phase
  `Phase`_ is defined as a Kustomize entrypoint and its relationship to a known
  Airship executor that takes the rendered document set and performs defined
  action on it. The goal of phases is to break up the delivery of artifacts
  into independent document sets. The most common example of such an executor
  is the built-in ``KubernetesApply`` executor which takes the rendered
  document set and applies it to a Kubernetes end-point and optionally waits
  for the workloads to be in a specific state. The airship community provides a
  set of predefined phases in Treasuremap that allow you to deploy a Kubernetes
  cluster and manage its workloads. But you can craft your own phases as well.

 Phase Plan
  A plan is a collection of phases that should be executed in sequential order.
  It provides the mechanism to easily orchestrate a number of phases. The
  purpose of the plan is to help achieve a complete end to end lifecycle with
  a single command. Airship Phase Plan is declared in your YAML library. There
  can be multiple plans, for instance, a plan defined for initial deployment,
  a plan for updates, and even plans for highly specific purposes. Plans can
  also share phases, which makes them another fairly light-weight construct and
  allows YAML engineers to craft any number of specific plans without
  duplicating plan definitions.

 Software defined networking (SDN)
  Software-defined networking technology is an approach to network management
  that enables dynamic, programmatically efficient network configuration in
  order to improve network performance and monitoring making it more like cloud
  computing than traditional network management.

 Stage
  A stage is a logical grouping of phases articulating a common purpose in the
  life cycle. There is no airshipctl command that relates to stages, but it is
  a useful notion for purposes of discussion that we define each of the stages
  that make-up the life cycle process.

.. _Helm:
    https://helm.sh

.. _Airshipctl repository:
    https://github.com/airshipit/airshipctl/tree/master/manifests/function/hardwareprofile-example

.. _Phase:
    https://docs.airshipit.org/airshipctl/phases.html

.. _KubernetesApply:
   https://github.com/airshipit/airshipctl/blob/master/pkg/phase/executors/k8s_applier.go

.. _GenericContainer:
   https://github.com/airshipit/airshipctl/blob/master/pkg/phase/executors/container.go

.. _Clusterctl:
   https://github.com/airshipit/airshipctl/blob/master/pkg/phase/executors/clusterctl.go
