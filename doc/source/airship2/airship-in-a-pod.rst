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

Airship in a Pod (AIAP)
=======================

Airship-in-a-Pod (AIAP) is a Kubernetes pod definition that describes all of the components required to deploy a fully functioning Airship 2 in a working Kubernetes cluster. The pod consists of the following "Task" containers:

* airshipctl-builder: This container builds the airshipctl binary and makes it available to the other containers. Airshipctl manages the lifecycle of a site utilizing declarations about the infrastructure (stored in source code).
* infra-builder: This container creates the various virtual networks and machines required for an Airship deployment.
* runner: The runner container is the "meat" of the pod, and executes the deployment.


The pod also contains the following "Support" containers:

* libvirt: This provides virtualization.
* sushy-tools: This is used for its Bare Metal Container (BMC) emulator.
* docker-in-docker: This is used for nesting containers.
* nginx: This is used for image hosting.

Prerequisites
------------------

Airship in a Pod (AIAP) is a pod definition. Deploying and using AIAP is as simple as deploying it on any Kubernetes pod on a Linux machine matching the following requirements.

* Linux bare metal server\* with KVM (server recommended specs: CPUs 4, RAM 16G, free disk space 60GB)
* Kubernetes\**
* kubectl\**
* Kubernetes cluster

\* This is our initial AIAP deployment platform. Additional deployment platforms are under consideration for future AIAP installments.
\** Please note that for compatibility the Kubernetes and kubectl releases should be within 1 release of each other.

Deploying a Kubernetes Cluster
----------------------------------------

First, we need a working Kubernetes cluster and these can be provided by tools such as `kubeadm <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/>`_, `minikube <https://minikube.sigs.k8s.io/docs/start/>`_ and `Docker Desktop <https://www.docker.com/products/docker-desktop>`_. The instructions to "Deploy AIAP" using kubectl are agnostic to how the kubernetes cluster is deployed.

In this example we shall utilize minikube to provide us with a Kubernetes cluster; minikube requires that we also deploy the docker-ce engine.

Pre-deploy needed utilites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

	sudo apt-get install  apt-transport-https  \
		ca-certificates curl  gnupg  lsb-release

Deploy minikube
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Exceute the following in a terminal (cmd or shell) window:

 .. code-block:: bash

	wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo chmod 755 minikube-linux-amd64
	sudo mv minikube-linux-amd64 /usr/local/bin/minikube

Deploy Docker
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

	sudo apt-get update

Add Docker GPG key

.. code-block:: bash

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Add stable directory

.. code-block:: bash

	sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable"

Update package

.. code-block:: bash

	sudo apt update
	apt-cache policy docker-ce

Install

.. code-block:: bash

	sudo apt-get install docker-ce docker-ce-cli containerd.io

Add Docker User

.. code-block:: bash

 	sudo usermod -aG docker $USER && newgrp docker

To check Docker status

.. code-block:: bash

	sudo systemctl status docker

Start minikube
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This will install kubernetes and create a kubernetes "default" cluster.

.. code-block:: bash

	minikube start --cpus=4 --memory=16384 --driver=none

Please note that you can specify a smaller configuration or let minikube utilize the default configuraion by not specifying cpus or memory but, if resources permit, the above specifiction is highly recommended.

Deploy AIAP
--------------------

The `airship-in-a-pod.yaml <https://github.com/airshipit/airshipctl/blob/master/tools/airship-in-a-pod/airship-in-a-pod.yaml>`_  file contains declarations about the seven (7) containers (listed previously). To deploy AIAP once a kubernetes cluster is available:

.. code-block:: bash

	$ kubectl apply -f https://raw.githubusercontent.com/airshipit/airshipctl/master/tools/airship-in-a-pod/airship-in-a-pod.yaml

You should see the message "airship-in-a-pod" created. The deployment of the containers will take some time.

View Pod Logs
~~~~~~~~~~~~~~

.. code-block:: bash

	kubectl logs airship-in-a-pod -c $CONTAINER

Usage
-----------------------------

Interact with the Pod
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

	kubectl exec -it airship-in-a-pod -c $CONTAINER -- bash

where $CONTAINER is one of the containers listed above.


Output
~~~~~~~~~~~~~~~~~~~~~

Airship-in-a-pod produces the following outputs:

    - The airshipctl repo and associated binary used with the deployment
    - A tarball containing the generated ephemeral ISO, as well as the configuration used during generation.

These artifacts are placed at ARTIFACTS_DIR (defaults to /opt/aiap-artifacts).


Caching
~~~~~~~~~~~~~~~~~~~~~

As it can be cumbersome and time-consuming to build and rebuild binaries and images, some options are made available for caching. A developer may re-use artifacts from previous runs (or provide their own) by placing them in CACHE_DIR (defaults to /opt/aiap-cache). Special care is needed for the caching:

    - If using a cached airshipctl, the airshipctl binary must be stored in the $CACHE_DIR/airshipctl/bin/ directory, and the developer must have set USE_CACHED_AIRSHIPCTL to true.
    - If using a cached ephemeral iso, the iso must first be contained in a tarball named iso.tar.gz, must be stored in the $CACHE_DIR/ directory, and the developer must have set USE_CACHED_ISO to true.
