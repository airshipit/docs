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

Integration with Cluster API Providers
======================================

The `Cluster-API`_ (CAPI) is a Kubernetes project to bring declarative,
Kubernetes-style APIs to cluster creation, configuration, and management. By
leveraging the Cluster-API for cloud provisioning, Airship takes advantage
of upstream efforts to build Kubernetes clusters and manage their lifecycle.
Most importantly, we can leverage a number of ``CAPI`` providers that already
exist. This allows Airship deployments to target both public and private
clouds, such as Azure, AWS, and OpenStack.

The Site Authoring Guide and Deployment Guide in this document focus on
deployment on the bare metal infrastructure, where Airship utilizes the
``Metal3-IO`` Cluster API Provider for Managed Bare Metal Hardware (CAPM3) and
Cluster API Bootstrap Provider Kubeadmin (CABPK).

There are Cluster-API Providers that support Kubernetes deployments on top of
already provisioned infrastructure, enabling Bring Your Own bare metal use
cases as well. Here is a list of references on how to use Airshipctl to create
Cluster API management cluster and workload clusters on various different
infrastructure providers:

   * `Airshipctl and Cluster API Docker Integration`_
   * `Airshipctl and Cluster API Openstack Integration`_
   * `Airshipctl and Cluster API GCP Provider Integration`_
   * `Airshipctl and Azure Cloud Platform Integration`_

.. _Cluster-API:
    https://github.com/kubernetes-sigs/cluster-api
.. _Airshipctl and Cluster API Docker Integration:
    https://docs.airshipit.org/airshipctl/providers/cluster_api_docker.html
.. _Airshipctl and Cluster API Openstack Integration:
    https://docs.airshipit.org/airshipctl/providers/cluster_api_openstack.html
.. _Airshipctl and Cluster API GCP Provider Integration:
    https://docs.airshipit.org/airshipctl/providers/cluster_api_gcp.html
.. _Airshipctl and Azure Cloud Platform Integration:
    https://docs.airshipit.org/airshipctl/providers/cluster_api_azure.html
