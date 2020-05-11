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

Develop Airship
===============

Welcome
-------

Thank you for your interest in Airship. Our community is eager to help you
contribute to the success of our project and welcome you as a member of our
community!

We invite you to reach out to us at any time via the `Airship mailing list`_ or
on our `Slack workspace`_.

Welcome aboard!

.. _Airship mailing list: http://lists.airshipit.org
.. _Slack workspace: http://airshipit.org/slack

Getting Started - Airship 2 Development
---------------------------------------

Development is underway on Airship 2: the educated evolution of Airship 1,
designed with our experience using Airship in production. Airship 2 makes the
Airship control plane ephemeral, leverages entrenched upstream projects such as
the `Cluster API`_, `Metal Kubed`_, Kustomize_, and `kubeadm`_, and embraces
Kubernetes Custom Resource Definitions (CRDs). To learn more about the Airship
2.0 evolution, see the `Airship 2 evolution blog series`_.

Each Airship 2 project has its own development guidelines. Join the ongoing Airship 2
development by referencing the `airshipctl`_ or the `airshipui`_ documentation.

.. _airshipctl: https://docs.airshipit.org/airshipctl/developers.html
.. _Airship 2 evolution blog series: https://www.airshipit.org/blog/airship-blog-series-1-evolution-towards-2.0
.. _airshipui: https://docs.airshipit.org/airshipui/developers.html
.. _Cluster API: https://github.com/kubernetes-sigs/cluster-api
.. _kubeadm: https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm
.. _Kustomize: https://github.com/kubernetes-sigs/kustomize
.. _Metal Kubed: https://metal3.io

Getting Started - Airship 1 Development
---------------------------------------

Airship 1 is a collection of open source tools that automate cloud provisioning
and management. Airship provides a declarative framework for defining and
managing the life cycle of open infrastructure tools and the underlying
hardware. These tools include OpenStack for virtual machines, Kubernetes for
container orchestration, and MaaS for bare metal, with planned support for
OpenStack Ironic.

Improvements are still made Airship 1 daily, and we welcome additional
contributors. We recommend that new contributors begin by reading the
high-level architecture overview included in our `treasuremap`_ documentation.
The architectural overview introduces each Airship component, their core
responsibilities, and their integration points.

.. _treasuremap: https://docs.airshipit.org/treasuremap

Deep Dive
~~~~~~~~~

Each Airship component is accompanied by its own documentation that provides an
extensive overview of the component. With so many components, it can be
challenging to find a starting point.

We recommend the following:

Try an Airship environment
~~~~~~~~~~~~~~~~~~~~~~~~~~

Airship provides two single-node environments for demo and development purpose.

`Airship-in-a-Bottle`_ is a set of reference documents and shell scripts that
stand up a full Airship environment with the execution of a script.

`Airskiff`_ is a light-weight development environment bundled with a set of
deployment scripts that provides a single-node Airship environment. Airskiff
uses minikube to bootstrap Kubernetes, so it does not include Drydock, MaaS, or
Promenade.

Additionally, we provide a reference architecture for easily deploying a
smaller, demo site.

`Airsloop`_ is a fully-authored Airship site that can be quickly deployed as a
baremetal, demo lab.

.. _Airship-in-a-Bottle: https://opendev.org/airship/in-a-bottle

.. _Airskiff: https://docs.airshipit.org/treasuremap/airskiff.html

.. _Airsloop: https://docs.airshipit.org/treasuremap/airsloop.html

Focus on a component
~~~~~~~~~~~~~~~~~~~~

When starting out, focusing on one Airship component allows you to become
intricately familiar with the responsibilities of that component and understand
its function in the Airship integration. Because the components are modeled
after each other, you will also become familiar with the same patterns and
conventions that all Airship components use.

Airship source code lives in the `OpenDev Airship namespace`_. To clone an
Airship project, execute the following, replacing `<component>` with the name
of the Airship component you want to clone.

.. code-block bash::

  git clone https://opendev.org/airship/<component>.git

Refer to the component's documentation to get started. A list of each
component's documentation is listed below for reference:

    * `Armada`_
    * `Deckhand`_
    * `Divingbell`_
    * `Drydock`_
    * `Pegleg`_
    * `Promenade`_
    * `Shipyard`_

.. _OpenDev Airship namespace: https://opendev.org/airship

.. _Armada: https://airship-armada.readthedocs.io

.. _Deckhand: https://airship-deckhand.readthedocs.io

.. _Divingbell: https://airship-divingbell.readthedocs.io

.. _Drydock: https://airship-drydock.readthedocs.io

.. _Pegleg: https://airship-pegleg.readthedocs.io

.. _Promenade: https://airship-promenade.readthedocs.io

.. _Shipyard: https://airship-shipyard.readthedocs.io

Testing Changes
~~~~~~~~~~~~~~~

Testing of Airship changes can be accomplished several ways:

    #. Standalone, single component testing
    #. Integration testing
    #. Linting, unit, and functional tests/linting

.. note:: Testing changes to charts in Airship repositories is best
    accomplished using the integration method describe below.

Standalone Testing
~~~~~~~~~~~~~~~~~~

Standalone testing of Airship components, i.e. using an Airship component as a
Python project, provides the quickest feedback loop of the three methods and
allows developers to make changes on the fly. We recommend testing initial code
changes using this method to see results in real-time.

Each Airship component written in Python has pre-requisites and guides for
running the project in a standalone capacity. Refer to the documentation listed
below.

    * `Armada`_
    * `Deckhand`_
    * `Drydock`_
    * `Pegleg`_
    * `Promenade`_
    * `Shipyard`_

Integration Testing
~~~~~~~~~~~~~~~~~~~

While each Airship component supports individual usage, Airship components
have several integration points that should be exercised after modifying
functionality.

We maintain several environments that encompass these integration points:

    #. `Airskiff`_: Integration of Armada, Deckhand, Shipyard, and Pegleg
    #. `Airship-in-a-Bottle Multinode`: Full Airship integration

For changes that merely impact software delivery components, exercising a full
Airskiff deployment is often sufficient. Otherwise, we recommend using the
Airship-in-a-Bottle Multinode environment.

Each environment's documentation covers the process required to build and test
component images.

.. _Airskiff: https://docs.airshipit.org/treasuremap/airskiff.html

.. _Airship-in-a-Bottle Multinode: http://git.openstack.org/cgit/openstack/
    airship-in-a-bottle/tree/tools/multi_nodes_gate/README.rst

Final Checks
~~~~~~~~~~~~

Airship projects provide Makefiles to run unit, integration, and functional
tests as well as lint Python code for PEP8 compliance and Helm charts for
successful template rendering. All checks are gated by Zuul before a change can
be merged. For more information on executing these checks, refer to
project-specific documentation.

Third party CI tools, such as Jenkins, report results on Airship-in-a-Bottle
patches. These can be exposed using the "Toggle CI" button in the bottom
left-hand page of any gerrit change.

Pushing code
~~~~~~~~~~~~

Airship uses the `OpenDev gerrit`_ for code review. Refer to the `OpenStack
Contributing Guide`_ for a tutorial on submitting changes to Gerrit code
review.

.. _OpenDev gerrit: https://review.opendev.org

.. _OpenStack Contributing Guide: https://docs.openstack.org/horizon/latest/contributor/contributing.html

Next steps
~~~~~~~~~~

Upon pushing a change to gerrit, Zuul continuous integration will post job
results on your patch. Refer to the job output by clicking on the job itself to
determine if further action is required. If it's not clear why a job failed,
please reach out to a team member in IRC. We are happy to assist!

Assuming all continuous integration jobs succeed, Airship community members and
core developers will review your patch and provide feedback. Many patches are
submitted to Airship projects each day. If your patch does not receive feedback
for several days, please reach out using IRC or the Airship mailing list.

Merging code
~~~~~~~~~~~~

Like most OpenDev projects, Airship patches require two +2 code review votes
from core members to merge. Once you have addressed all outstanding feedback,
your change will be merged.

Beyond
~~~~~~

Congratulations! After your first change merges, please keep up-to-date with
the team. We hold two weekly meetings for project and design discussion:

Our weekly #airshipit IRC meeting provides an opportunity to discuss project
operations.

Our weekly design call provides an opportunity for in-depth discussion of new
and existing Airship features.

For more information on the times of each meeting, refer to the `Airship
wiki`_.

.. _Airship wiki: https://wiki.openstack.org/wiki/Airship

.. toctree::
   :hidden:
   :maxdepth: 3

   getting-started
   conventions
