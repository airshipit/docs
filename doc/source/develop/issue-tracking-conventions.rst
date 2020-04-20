..
      Copyright 2020 AT&T Intellectual Property.
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

.. _issue-tracking-conventions:

Issue Tracking
==============

Issues for the Airship Project are tracked on a per-project basis using Github
Issues. All feature requests and bugs should be submitted to the respective
project's Github Issues board for community evaluation and action. For
additional details on a project's issue tracking workflow, see its
CONTRIBUTING.md file.

Project CONTRIBUTING.md Files:

-  `airshipctl CONTRIBUTING.md`_

Submitting Issues
-----------------
Issues can be submitted by navigating to a project's Github Issue page and
selecting "New issue".

Depending on the project, you may be prompted to select an issue
type. These selections are associated with templates to aid in the issue
creation process. If there are no templates associated with the project,
utilize the following templates:

-  `Feature Request Template`_
-  `Bug Report Template`_

When submitting issues, be descriptive and concise. If the issue is complex
consider breaking it down into smaller issues so it can be more easily
addressed by the community.

Grooming Issues
---------------
Issues are groomed by each project's core reviewers. Depending on how active
the project is and their workflow, it can take up to two weeks for issues to
be groomed. Issues will be marked with the "triage" label until they have been
groomed and prioritized. We encourage developers to not work on issues marked
as "triage" as these issues are not guaranteed to be accepted by the project.

Each project will have a multitude of labels used to help categorize issues and
improve organization. Labels will differ from project to project, but some
common labels may include:

-  Process labels ("ready for review", "wip", "blocked", "triage")
-  Priority labels ("priority/low", "priority/medium", "priority/high")
-  Component labels ("component/engine", "component/cli", etc...)
-  Type labels ("feature", "bug", "epic")

As many applicable labels as possible should be applied to issues. These labels
should be consistently reevaluated and updated as the issue evolves.

Issue Lifecycle
---------------
The general lifecycle for issues is as follows:

#. The issue is created by a member of the community on Github Issues. By
   default, the issues should have a type label and be labeled as "triage".
   Neither the submitter nor any other developer should work on the issue at
   this time, but they may discuss it on the Github Issue board to further
   clarify the issue.
#. The issue is groomed by members of the core reviewer team for the project,
   either on a scheduled grooming call or asynchronously on the Github Issues
   board. During the grooming process the core reviewer team will establish
   whether the issue is part of the project's scope and what the issue's
   priority level is. They will also apply a multitude of labels to help
   improve the organization of the issue board and the visibility of the issue.
   At the end of the process if the issue is accepted, the "triage" label will
   be removed and the issue will be available to be assigned and worked on. It
   is possible that the core reviewer team will need additional details. Please
   be attentive to updates on created issues to ensure they are addressed in a
   timely manner.
#. The issue is assigned to a member of the community to be addressed. Only
   core reviewers have the ability to assign issues. If a member of the
   community wishes to be assigned to an issue, they should make a comment on
   the issue requesting to have it assigned to them. Please only start work on
   an issue after it is assigned to you to decrease the risk of duplicate
   changes. Issue assignees are encouraged to use process labels to indicate
   where they are in the development workflow
   (i.e. "wip" or "ready for review"). Consistent updates let the core reviewer
   team know that the issue is still active. If no measurable work has been
   performed on an assigned issue within two weeks, the issue may be considered
   "stale" and the assignee may be removed from the issue.
#. Once a developer completes work on an issue's associated change (or
   research), they should indicate that work is complete and
   "ready for review". Include a link to the associated change along with any
   observations of worth in the issue's comments. Once the change is merged,
   the core reviewer team will mark the issue as completed.

Github Issues Bot
~~~~~~~~~~~~~~~~~
To help improve Gerrit and Github integration, Airship utilizes a python daemon
to update Github Issues with Gerrit change details. The utility is hosted on
Github under the name `Gerrit-to-Github-Issues`_. Currently the bot only runs
against the airshipctl project, but it may be implemented later into other
projects.

The bot performs the following functions:

-  Comments on issues with the information of active Gerrit changes including
   links, review statuses, and author information.
-  Updates issue process labels with the "wip" label if "DNM" or "WIP" are
   present in the change's commit message and "ready for review" in all other
   cases.

To leverage the bot's full functionality, be sure to include a reference for the
issue you are addressing from GitHub Issues inside the change commit message.
There are three ways of doing this:

#. Add a statement in your commit message in the format of ``Relates-To: #X``.
This will add a link on issue "#X" to your change.
#. Add a statement in your commit message in the format of ``Closes: #X``.
This will add a link on issue "#X" to your change and will close the issue when
your change merges.
#. Add a bracketed tag at the beginning of your commit message in the format of
``[#X] <begin commit message>``. This will add a link on issue "#X" to your
change. This method is considered a fallback in lieu of the other two methods.

Any issue references should be evaluated within 15 minutes of being uploaded.

For any questions, comments, or requests please reach out to Ian Pittwood
either at ian-pittwood on the Airship IRC/Slack or at pittwoodian@gmail.com.

.. _airshipctl Issue Tracker: https://github.com/airshipit/airshipctl/issues
.. _airshipctl CONTRIBUTING.md: https://opendev.org/airship/airshipctl/src/branch/master/CONTRIBUTING.md
.. _Feature Request Template: https://opendev.org/airship/docs/raw/branch/master/doc/source/develop/issue_templates/feature_request.md
.. _Bug Report Template: https://opendev.org/airship/docs/raw/branch/master/doc/source/develop/issue_templates/bug_report.md
.. _Gerrit-to-Github-Issues: https://github.com/ianpittwood/Gerrit-to-Github-Issues