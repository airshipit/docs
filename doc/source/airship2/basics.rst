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

.. _basics:

Airship 2 Basics
================

What is Airship 2 (AS2)?
------------------------
Airship is a collection of interoperable open source cloud provisioning tools that provide a robust delivery mechanism for organizations that want to embrace containers as the new unit of infrastructure delivery at scale.  Starting with bare metal infrastructure, Airship manages the full infrastructure life cycle to deliver and manage a Kubernetes cluster, with Helm deployed artifacts, for development and production.  As the version implies, Airship 2 (AS2) is the second major release of the Airship tool set.

Why did Airship come into existence?
------------------------------------
The use of open source components for cloud deployments provide many benefits: 

    - Open source software is often free.
    - Communities of users, developers, and contributors develop cloud functionality based on practical needs and use cases requiring cloud platform technology.
    - Services for orchestration of compute, network, and storage, as well as fault management are open source driven and supported.  

The challenges, however, are the technical aptitude, maturity, and experience required to integrate and maintain these open source components to provide a complex cloud platform to run client applications.  **Airship was born** from the need to streamline and simplify the use of open source tools for deployment and management of cloud infrastructure.

What does Airship 2 do?
-----------------------
Airship allows operators an ability to deploy complex Kubernetes-based cloud infrastructure and manage its infrastructure life cycle.  Airship applies principles of application management to cloud infrastructure operation.  Hard assets, such as bare metal servers and network settings, are managed alongside soft assets, such as the Helm charts and application containers.

How does Airship 2 (AS2) differ from Airship 1 (AS1)?
-----------------------------------------------------
The evolution of Airship 2 includes the following improvements from Airship 1:

- Smaller, ephemeral footprint
- Adoption of established upstream Cloud Native Computing Foundation (CNCF) projects
- Expanded support for multiple platforms
- Less downstream customization of manifests
- Introduction of phases & phase plans
- Airship UI is planned and will enhance the user experience
- Improved speed of deployment vs. Airship 1.0 
- Airship in a Pod (AIAP) demonstrates improved onboarding experience gained through AS2 capabilities and functionality

How does AS2 work?
------------------
Airship has a single workflow for managing both initial installations and updates through declarative YAML documents describing an Airship target environment.  These YAML documents provide for declaration of the entire infrastructure up front. This declarative approach allows Airship to provide a repeatable and predictable mechanism for maintaining service-critical infrastructure and the software running there.

An operator only needs to make a change to an Airship YAML configuration when defining or changing cloud infrastructure based on the deployment need, and Airship performs the heavy-lifting automatically completing the needed work. When managing complex Infrastructure-as-a-Service (IaaS) projects, anything from minor service configuration updates to major upgrades are all handled in the same way: by simply modifying the YAML configuration and submitting it to the Airship runtime.

Benefits of AS2
---------------
**Platform Integration:** Airship deploys an integrated virtualization and containerization platform, utilizing Kubernetes and Helm. Airship deploys and manages the infrastructure, platform components and services.  Airship is a resilient application deployment and life cycle engine that functions with any Helm chart based application.

**Security at Scale:** Airship 2 leverages native security tools and services such as `Secure Computing (seccomp) <https://man7.org/linux/man-pages/man2/seccomp.2.html>`_, `Mandatory Access Controls (MAC) <https://www.linux.com/news/securing-linux-mandatory-access-controls/>`_, and `Pod Security Policies (PSP) <https://kubernetes.io/docs/concepts/policy/pod-security-policy/>`_, across the entire toolchain for delivery, development, and management of cloud based software and infrastructure. 
These tools coupled with `Transport Layer Security (TLS) <https://kb.intermedia.net/article/22904>`_-enabled service endpoints and encrypted storage of secrets ensure a secure platform for system calls, file access, and application controls.

**Scalable Operations:** By leveraging Kubernetes and Helm, critical services can automatically scale under load and can robustly survive hardware failure. The deployed platform can easily bundle many tools required to operate the cloud infrastructure including, for example, leveraging OpenStack-Helm, network security policies, or tools such as for log collection, search capabilities, monitoring, alerting, and graphing.

**Reliable Upgrades:** Critical services can be upgraded with confidence, with gradual roll-outs (including the ability to roll-back), and guaranteed data and virtual machine integrity across container application upgrades, with minimal (or no) need to shut down services or live-migrate virtual machines through the upgrade process.
