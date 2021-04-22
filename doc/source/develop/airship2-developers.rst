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

===============
Getting Started
===============

Thank you for your interest in Airship. Our community is eager to help you
contribute to the success of our project and welcome you as a member of our
community!

We invite you to reach out to us at any time via the `Airship mailing list`_ or
on our `Slack workspace`_.

Welcome aboard!

.. _Airship mailing list: http://lists.airshipit.org
.. _Slack workspace: http://airshipit.org/slack

=====================
Airship 2 Development
=====================

Development is underway on Airship 2: the educated evolution of Airship 1,
designed with our experience using Airship in production. Airship 2 makes the
Airship control plane ephemeral, leverages entrenched upstream projects such as
the `Cluster API`_, `Metal Kubed`_, Kustomize_, and `kubeadm`_, and embraces
Kubernetes Custom Resource Definitions (CRDs). To learn more about the Airship
2.0 evolution, see the `Airship 2 evolution blog series`_.

Each Airship 2 project has its own development guidelines. Join the ongoing Airship 2
development by referencing the `airshipctl`_ or the `airshipui`_ documentation.

.. _airshipctl: https://docs.airshipit.org/airshipctl/developers.html
.. _Airship 2 evolution blog series: https://www.airshipit.org/blog/airship-update-march-2021
.. _airshipui: https://docs.airshipit.org/airshipui/developers.html
.. _Cluster API: https://github.com/kubernetes-sigs/cluster-api
.. _kubeadm: https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm
.. _Kustomize: https://github.com/kubernetes-sigs/kustomize
.. _Metal Kubed: https://metal3.io

Testing Changes
---------------

Testing of Airship changes can be accomplished several ways:

    #. Standalone, single component testing
    #. Integration testing
    #. Linting, unit, and functional tests/linting

.. note:: Testing changes to charts in Airship repositories is best
    accomplished using the integration method describe below.

Final Checks
------------

Airship projects provide Makefiles to run unit, integration, and functional
tests as well as lint Python code for PEP8 compliance and Helm charts for
successful template rendering. All checks are gated by Zuul before a change can
be merged. For more information on executing these checks, refer to
project-specific documentation.

Third party CI tools, such as Jenkins, report results on Airship-in-a-Bottle
patches. These can be exposed using the "Toggle CI" button in the bottom
left-hand page of any gerrit change.

Pushing code
------------

Airship uses the `OpenDev gerrit`_ for code review. Refer to the `OpenStack
Contributing Guide`_ for a tutorial on submitting changes to Gerrit code
review.

.. _OpenDev gerrit: https://review.opendev.org

.. _OpenStack Contributing Guide: https://docs.openstack.org/horizon/latest/contributor/contributing.html

Next steps
----------

Upon pushing a change to gerrit, Zuul continuous integration will post job
results on your patch. Refer to the job output by clicking on the job itself to
determine if further action is required. If it's not clear why a job failed,
please reach out to a team member in IRC. We are happy to assist!

Assuming all continuous integration jobs succeed, Airship community members and
core developers will review your patch and provide feedback. Many patches are
submitted to Airship projects each day. If your patch does not receive feedback
for several days, please reach out using IRC or the Airship mailing list.

Merging code
------------

Like most OpenDev projects, Airship patches require two +2 code review votes
from core members to merge. Once you have addressed all outstanding feedback,
your change will be merged.

Beyond
------

Congratulations! After your first change merges, please keep up-to-date with
the team. We hold two weekly meetings for project and design discussion:

Our weekly #airshipit IRC meeting provides an opportunity to discuss project
operations.

Our weekly design call provides an opportunity for in-depth discussion of new
and existing Airship features.

For more information on the times of each meeting, refer to the `Airship
wiki`_.

.. _Airship wiki: https://wiki.openstack.org/wiki/Airship
