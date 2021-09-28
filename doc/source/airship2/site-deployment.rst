.. _site_deployment_guide:

Site Deployment Guide
=====================

This document is the Airship 2 site deployment guide for a standard greenfield
bare metal deployment. The following sections describes how to apply the site
manifests for a given site.

Prerequisites
~~~~~~~~~~~~~

Before starting, ensure that you have completed :ref:`system requirements and set up <site_setup_guide>`,
including the the BIOS and Redfish settings, hardware RAID configuration etc.

.. warning::

   Ensure all the hosts are powered off, including ephemeral node, controller
   nodes and worker nodes.

Airshipctl Phases
~~~~~~~~~~~~~~~~~

A new concept with Airship 2 is :term:`phases<Phase>`. A phase is a step to be
performed in order to achieve a desired state of the managed site. Phases group
sets of commands together for a particular deployment step into one phase apply
command. This greatly simplifies executing deployment.

The Airship 2 deployment uses heavily the ``airshipctl`` commands, especially the
``airshipctl phase run`` commands. You may find it helpful to get familiarized with
the `airshipctl command reference`_ and `example usage`_.

To facilitate the site deployment, the Airship Treasuremap project provides a
set of deployment scripts in the ``tools/deployment`` directory. These scripts
are wrappers of the `airshipctl` commands with additional flow controls. They
are numbered sequentially in the order of the deployment operations.

The instructions in this document will be based upon the Treasuremap deployment
scripts.

.. _airshipctl command reference:
    https://docs.airshipit.org/airshipctl/cli/airshipctl.html
.. _example usage:
    https://docs.airshipit.org/airshipctl/architecture.html#example-usage

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

The deployment steps below use a few additional environment variables that are
already configured with default values for a typical deployment or inferred
from other configuration files or site manifests. In most situations, users
do not need to manually set the values for these environment variables.

 * ``KUBECONFIG``: The location of the kubeconfig file. Default value:
   ``$HOME/.airship/kubeconfig``.
 * ``KUBECONFIG_TARGET_CONTEXT``: The name of the kubeconfig context for the
   target cluster. Default value: "target-cluster". You can find it defined
   in the Airshipctl configuration file.
 * ``KUBECONFIG_EPHEMERAL_CONTEXT``: The name of the kubeconfig context for
   the ephemeral cluster. Default value: "ephemeral-cluster". You can find it
   defined in the Airshipctl configuration file.
 * ``TARGET_IP``: The control plane endpoint IP or host name. Default value:
   derived from site documents for the ``controlplane-target`` phase. You
   can run the following command to extract the defined value:

   .. code-block:: bash

     airshipctl phase render controlplane-target \
     -k Metal3Cluster -l airshipit.org/stage=initinfra \
     2> /dev/null | yq .spec.controlPlaneEndpoint.host | sed 's/"//g'

 * ``TARGET_PORT``: The control plane endpoint port number. Default value:
   derived from site documents for the ``controlplane-target`` phase. You
   can run the following command to extract the defined value:

   .. code-block:: bash

     airshipctl phase render controlplane-target \
     -k Metal3Cluster -l airshipit.org/stage=initinfra 2> /dev/null | \
     yq .spec.controlPlaneEndpoint.port

 * ``TARGET_NODE``: The host name of the first controller node. Default
   value: derived from site documents for the ``controlplane-ephemeral``
   phase. You can run the following command to extract the defined value:

   .. code-block:: bash

     airshipctl phase render controlplane-ephemeral \
     -k BareMetalHost -l airshipit.org/k8s-role=controlplane-host 2> /dev/null | \
     yq .metadata.name | sed 's/"//g'

 * ``WORKER_NODE``: The host name of the worker nodes. Default value: derived
   from site documents for the ``workers-target`` phase. You can run the
   following command to extract the defined value:

   .. code-block:: bash

     airshipctl phase render workers-target -k BareMetalHost 2> /dev/null | \
     yq .metadata.name | sed 's/"//g'

Configuring Airshipctl
~~~~~~~~~~~~~~~~~~~~~~

Airship requires a configuration file set that defines the intentions for the
site that needs to be created. These configurations include such items as
manifest repositories, ephemeral and target cluster context and bootstrap
information. The operator seeds an initial configuration using the
configuration initialization function.

The default location of the configuration files is ``$HOME/.airship/config``
and ``$HOME/.airship/kubeconfig``.

When you run the init_site script in the :ref:`init_site` section, the
``.airship/config`` file has been already created for you.

.. warning::
  If the Redfish api uses self-signed certificate, the user must run:

  .. code-block:: bash

        airshipctl config set-management-config default --insecure

  This will inject the ``insecure`` flag to the Airship configuration file as
  follows:

  .. code-block:: yaml

      managementConfiguration:
        default:
          insecure: true
          systemActionRetries: 30
          systemRebootDelay: 30
          type: redfish

Now let's create the ``.airship/kubeconfig``. If you plan to use an existing
external kubeconfig file, run:

.. code-block:: bash

    airshipctl config import <KUBE_CONFIG>

Otherwise, create an empty kubeconfig that will be populated later by
airshipctl:

.. code-block:: bash

   touch ~/.airship/kubeconfig

More advanced users can use the Airshipctl config commands to generate or
update the configuration files.

To generate an Airshipctl config file from scratch,

.. code-block:: bash

    airshipctl config init [flags]

To specify the location of the manifest repository,

.. code-block:: bash

    airshipctl config set-manifest <MANIFEST_NAME> [flags]

To create or modify a context in the airshipctl config files,

.. code-block:: bash

    airshipctl config set-context <CONTEXT_NAME> --manifest <MANIFEST_NAME> [flags]

Full details on the ``config`` command can be found here_.

.. _here: https://docs.airshipit.org/airshipctl/cli/config/airshipctl_config.html

.. _gen_secrets:

Generating and Encrypting Secrets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Airship site manifests contain different types of secrets, such as passwords,
keys and certificates in the variable catalogues. Externally provided secrets,
such as BMC credentials, are used by Airship and Kubernetes and can also be
used by other systems. Secrets can also be internally generated by Airshipctl,
e.g., Openstack Keystone password, that no external systems will provide or
need.

To have Airshipctl generate and encrypt the secrets, run the following script
from the treasuremap directory:

.. code-block:: bash

    ./tools/deployment/23_generate_secrets.sh

The generated secrets will be updated in:

   * ``${PROJECT}/manifests/site/${SITE}/target/generator/results/generated/secrets.yaml``
   * ``${HOME}/.airship/kubeconfig.yaml``

It is recommended that you save the generated results, for example, commit them
to a git repository along with the rest of site manifests.

To update the secrets for an already deployed site, you can re-run this script
and apply the new secret manifests by re-deploying the whole site.

For more details and trouble shooting, please refer to
`Secrets generation and encryption how-to-guide <https://github.com/airshipit/airshipctl/blob/master/docs/source/secrets-guidelines.md>`_.

Validating Documents
~~~~~~~~~~~~~~~~~~~~

After constituent YAML configurations are finalized, use the document
validation tool to lint and check the new site manifests. Resolve any
issues that result from the validation before proceeding.

.. code-block:: bash

    ./tools/validate_docs

.. caution::

    The validate_docs tool will run validation against all sites found in the
    ``manifests/site`` folder. You may want to (temporarily) remove other sites
    that are not to be deployed to speed up the validation.

To validate a single site's manifest,

.. code-block:: bash

     export MANIFEST_ROOT=./${PROJECT}/manifests
     export SITE_ROOT=./${PROJECT}/manifests/site
     cd airshipctl && ./tools/document/validate_site_docs.sh

Estimated runtime: **5 minutes**

Building Ephemeral ISO Image
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The goal for this step is to generate a custom targeted image for bootstrapping
an ephemeral host with a Kubernetes cluster installed. This image may then
be published to a repository to which the ephemeral host will have remote access.
Alternatively, an appropriate media delivery mechanism (e.g. USB) can be used to
bootstrap the ephemeral host manually.

.. note:: The generate ISO image content includes:

  - Host OS Image
  - Runtime engine: Docker/containerd
  - Kubelet
  - Kubeadm
  - YAML file for KubeadmConfig

First, create an output directory for ephemeral ISO image and run the
``bootstrap-iso`` phase:

.. code-block:: bash

    sudo mkdir /srv/images
    airshipctl phase run bootstrap-iso

Or, run the provided script from the treasuremap directory:

.. code-block:: bash

    ./tools/deployment/24_build_images.sh

Then, copy the generated ephemeral ISO image to the Web hosting server that
will serve the ephemeral ISO image. The URL for the image should match what is
defined in
``manifests/site/{SITE}/ephemeral/bootstrap/remote_direct_configuration.yaml``.

For example, if you have installed the Apache Web server on the jump host as
described in the earlier step, you can simply execute the following:

.. code-block:: bash

    sudo cp /srv/images/ephemeral.iso /var/www/html/

Estimated runtime: **5 minutes**

Deploying Ephemeral Node
~~~~~~~~~~~~~~~~~~~~~~~~

In this step, we will create an ephemeral Kubernetes instance that ``airshipctl``
can communicate with for subsequent steps. This ephemeral host provides a
foothold in the target environment so the standard ``cluster-api`` bootstrap
flow can be executed.

First, let's deploy the ephemeral node via Redfish with the ephemeral ISO image
generated in previous step:

.. code-block:: bash

    ./tools/deployment/25_deploy_ephemeral_node.sh

Estimated runtime: **10 minutes**

.. note:: If desired or if Redfish is not available, the ISO image can be
  mounted through other means, e.g. out-of-band management or a USB drive.

Now the ephemeral node is established, we can deploy ``Calico``, ``metal3.io`` and
``cluster-api`` components onto the ephemeral node:

.. code-block:: bash

    ./tools/deployment/26_deploy_capi_ephemeral_node.sh

Estimated runtime: **10 minutes**

To use ssh to access the ephemeral node, you will need the OAM IP from the
networking catalogue, and the user name and password from the airshipctl phase
render command output.

.. code-block:: bash

    airshipctl phase render iso-cloud-init-data

Deploying Target Cluster
~~~~~~~~~~~~~~~~~~~~~~~~

Now you are ready to use the ephemeral Kubernetes to provision the first target
cluster node using the cluster-api bootstrap flow.

Create the target Kubernetes cluster resources:

.. code-block:: bash

    ./tools/deployment/30_deploy_controlplane.sh

Estimated runtime: **25 minutes**

Deploy infrastructure components including Calico and meta3.io:

.. code-block:: bash

    ./tools/deployment/31_deploy_initinfra_target_node.sh

Estimated runtime: **10 minutes**

Deploy ``cluster-api`` components to the target cluster:

.. code-block:: bash

    ./tools/deployment/32_cluster_init_target_node.sh

Estimated runtime: **1-2 minutes**

Then, stop the ephemeral host and move Cluster objects to target cluster:

.. code-block:: bash

    ./tools/deployment/33_cluster_move_target_node.sh

Estimated runtime: **1-2 minutes**

Lastly, complete the target cluster by provisioning the rest of the controller
nodes:

.. code-block:: bash

    ./tools/deployment/34_deploy_controlplane_target.sh

Estimated runtime: **30 minutes** (Depends on the number of controller nodes).

.. note::

   When the second controller node joins the cluster, the script may fail with
   the error message ``"etcdserver: request timed out"``. This is a known issue.
   You can just wait until all the other controller nodes join the cluster
   before executing the next phase. To check the list of nodes in the cluster,
   run:

.. code-block:: bash

   kubectl --kubeconfig ${HOME}/.airship/kubeconfig --context target-cluster get nodes

Provisioning Worker Nodes
~~~~~~~~~~~~~~~~~~~~~~~~~

This step uses the target control plane Kubernetes host to provision the
target cluster worker nodes and apply the necessary phases to deploy software
on the worker nodes.

To deploy, classify and provision the worker nodes, run:

.. code-block:: bash

    ./tools/deployment/35_deploy_worker_node.sh

Estimated runtime: **20 minutes**

Now the target cluster is fully operational and ready for workload deployment.

Deploying Workloads
~~~~~~~~~~~~~~~~~~~

The Treasuremap type ``airship-core`` deploys the ingress as a workload. The
user can add other workload functions to the target workload phase in the
``airship-core`` type, or create their own workload phase from scratch.

Adding a workload function involves two tasks. First, the user will create the
function manifest(s) in the ``$PROJECT/manifest/function`` directory. A good
example can be found in the `ingress`_ function from Treasuremap. Second, the
user overrides the `kustomization`_ of the target workload phase to include
the new workload function in the
``$PROJECT/manifests/site/$SITE/target/workload/kustomization.yaml``.

For more detailed reference, please go to `Kustomize`_ and airshipctl `phases`_
documentation.

.. _ingress: https://github.com/airshipit/treasuremap/tree/v2.0/manifests/function/ingress

.. _kustomization: https://github.com/airshipit/treasuremap/blob/v2.0/manifests/type/airship-core/target/workload/kustomization.yaml

.. _Kustomize: https://kustomize.io

.. _phases: https://docs.airshipit.org/airshipctl/phases.html

To deploy the workloads, run:

.. code-block:: bash

    ./tools/deployment/36_deploy_workload.sh

Estimated runtime: Varies by the workload content.

Accessing Nodes
~~~~~~~~~~~~~~~

Operators can use ssh to access the controller and worker nodes via the OAM IP
address. The ssh key can be retrieved using the airshipctl phase render command:

.. code-block:: bash

   airshipctl phase render controlplane-ephemeral

Tearing Down Site
~~~~~~~~~~~~~~~~~

To tear down a deployed bare metal site, the user can simply power off all
the nodes and clean up the deployment artifacts on the build node as follows:

.. code-block:: bash

   airshipctl baremetal poweroff --name <server-name> # alternatively, use iDrac or iLO
   rm -rf ~/.airship/ /srv/images/*
   docker rm -f -v $(sudo docker ps --all -q | xargs -I{} sudo bash -c 'if docker inspect {} | grep -q airship; then echo {} ; fi')
   docker rmi -f $(sudo docker images --all -q | xargs -I{} sudo bash -c 'if docker image inspect {} | grep -q airship; then echo {} ; fi')

