..
      Copyright 2017 AT&T Intellectual Property.
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

.. _code-conventions:

Code and Project Conventions
============================

Conventions and standards that guide the development and arrangement of Airship
component projects.

Project Structure
-----------------

Charts
~~~~~~
Each project that maintains helm charts will keep those charts in a directory
``charts`` located at the root of the project. The charts directory will
contain subdirectories for each of the charts maintained as part of that
project. These subdirectories should be named for the component represented by
that chart.

E.g.: For project ``foo``, which also maintains the charts for ``bar`` and
``baz``:

-  foo/charts/foo contains the chart for ``foo``
-  foo/charts/bar contains the chart for ``bar``
-  foo/charts/baz contains the chart for ``baz``

Helm charts utilize the `helm-toolkit`_ supported by the `Openstack-Helm`_ team
and follow the standards documented there.

Images
~~~~~~
Each project that creates `Docker`_ images will keep Dockerfiles in a
directory ``images`` located at the root of the project. The images directory
will contain subdirectories for each of the images created as part of that
project. The subdirectory will contain Dockerfiles that can be used to
generate images.

E.g.: For project ``foo``, which also produces a Docker image for ``bar``:

-  foo/images/foo contains Dockerfiles for ``foo``
-  foo/images/bar contains Dockerfiles for ``bar``

Each image must include the following set of labels conforming to the
`OCI image annotations standard`_ as the minimum:

::

    org.opencontainers.image.authors='airship-discuss@lists.airshipit.org, irc://#airshipit@freenode'
    org.opencontainers.image.url='https://airshipit.org'
    org.opencontainers.image.documentation='<documentation on readthedocs or in repository URL>'
    org.opencontainers.image.source='<repository URL>'
    org.opencontainers.image.vendor='The Airship Authors'
    org.opencontainers.image.licenses='Apache-2.0'
    org.opencontainers.image.revision='<Git commit ID>'
    org.opencontainers.image.created='UTC date and time in RFC3339 format with seconds'
    org.opencontainers.image.title='<image name, e.g. "armada">'

Last three annotations (revision, created and title), being dynamic, are
added on a container build stage. Others are statically defined in
Dockerfiles. Optional custom ``org.airshipit.build=community`` annotation is
added to the Airship images published to the community.

Image tags must follow format:

- ``:<full Git commit ID>_<distro_suffix>``
- ``:<branch>_<distro_suffix>`` - latest image built from specific branch
- ``:latest_<distro_suffix>`` - latest image built from master

The ``_<distro suffix>`` (e.g. ``_ubuntu_xenial``) could be omitted. See
`Airship Multiple Linux Distribution Support`_ specification for details.

Images should follow best practices for the container images. Be slim and
secure in particular.

Dockerfile
~~~~~~~~~~
Dockerfile file names must follow format: ``Dockerfile.<distro_suffix>``, where
``<distro_suffix>`` matches corresponding image tag suffix. The
``.<distro_suffix>`` could be omitted where not relevant.

Lines should be indented by a space character next to the Dockerfile
instruction block they correspond to.

Dockerfile must allow base image substitution via ``FROM`` argument. This is
to allow the use of base images stored in third-party or internal repositories.

Dockerfile should follow best practices. Use multistage container builds where
possible to reduce image size and attack surface. ``RUN`` statements should
pass linting via ``shellcheck``. You may use available Dockerfile linters, if
you wish to do so.

See `example Dockerfile`_ file for reference.

Makefile
~~~~~~~~
Each project must provide a Makefile at the root of the project. The Makefile
should implement each of the following Makefile targets:

-  ``images`` will produce the docker images for the component and each other
   component it is responsible for building.
-  ``charts`` will helm package all of the charts maintained as part of the
   project.
-  ``lint`` will perform code linting for the code and chart linting for the
   charts maintained as part of the project, as well as any other reasonable
   linting activity.
-  ``dry-run`` will produce a helm template for the charts maintained as part
   of the project.
-  ``all`` will run the lint, charts, and images targets.
-  ``docs`` should render any documentation that has build steps.
-  ``run_{component_name}`` should build the image and do a rudimentary (at
   least) test of the image's functionality.
-  ``run_images`` performs the inidividual run_{component_name} targets for
   projects that produce more than one image.
-  ``tests`` to invoke linting tests (e.g. PEP-8) and unit tests for the
   components in the project
-  ``format`` to invoke automated code formatting specific to the project's
   code language (e.g. Python for armada and Go for airshipctl) as listed
   in the Linting and Formatting Standards.

For projects that are Python based, the Makefile targets typically reference
tox commands, and those projects will include a tox.ini defining the tox
targets. Note that tox.ini files will reside inside the source directories for
modules within the project, but a top-level tox.ini may exist at the root of
the repository that includes the necessary targets to build documentation.

Documentation
~~~~~~~~~~~~~
Also see :ref:`documentation-conventions`.

Documentation source for the component should reside in a 'docs' directory at
the root of the project.

Linting and Formatting Standards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Code in the Airship components should follow the prevalent linting and
formatting standards for the language being implemented.  In lieu of industry
accepted code formatting standards for a target language, strive for
readability and maintainability.

===============  ======================================
Known Standards
-------------------------------------------------------
Language         Tools Used
===============  ======================================
Ansible          ansible-lint
Bash             Shellcheck
Go               gofmt
Markdown         markdownlint
Python           YAPF, Flake8
===============  ======================================

Ansible formatting
~~~~~~~~~~~~~~~~~~

Ansible code should be linted to be conformant to the standards checked
by `ansible-lint`_ project.

Bash Formatting
~~~~~~~~~~~~~~~

Bash shell scripts code should be linted to be conformant to the standards
checked by `Shellcheck`_ project.

Bash shell scripts code in Helm templates should ideally be linted as well,
however gating of it is a noble goal and is only desired.

Go Formatting
~~~~~~~~~~~~~

Go code should be formatted using gofmt. When using gofmt be sure to use the
-s flag to include simplification of code for example::

  gofmt -s /path/to/file.go

Markdown Formatting
~~~~~~~~~~~~~~~~~~~

Markdown code (documentation) should be linted to be conformant to the
standards checked by `markdownlint`_ project.

Python PEP-8 Formatting
~~~~~~~~~~~~~~~~~~~~~~~

Python should be formatted via YAPF. The knobs for YAPF can be specified in
the project's root directory in '.style.yapf'. The contents of this file should
be::

  [style]
  based_on_style = pep8
  spaces_before_comment = 2
  column_limit = 79
  blank_line_before_nested_class_or_def = false
  blank_line_before_module_docstring = true
  split_before_logical_operator = true
  split_before_first_argument = true
  allow_split_before_dict_value = false
  split_before_arithmetic_operator = true

A sample Flake8 section is below, for use in tox.ini, and is the
method of enforcing import orders via Flake8 extension
flake8-import-order::

  [flake8]
  filename = *.py
  show-source = true
  # [H106] Don't put vim configuration in source files.
  # [H201] No 'except:' at least use 'except Exception:'
  # [H904] Delay string interpolations at logging calls.
  enable-extensions = H106,H201,H904
  # [W503] line break before binary operator
  ignore = W503
  exclude=.venv,.git,.tox,build,dist,*lib/python*,*egg,tools,*.ini,*.po,*.pot
  max-complexity = 24


Airship components must provide for automated checking of their formatting
standards, such as the lint step noted above in the Makefile, and in the future
via CI jobs. Components may provide automated reformatting.

YAML Schema
~~~~~~~~~~~
YAML schema defined by Airship should have key names that follow camelCase
naming conventions.

Note that Airship also integrates and consumes a number of projects from
other open source communities, which may have their own style conventions,
and which will therefore be reflected in Airship deployment manifests.
Those fall outside the scope of these Airship guidelines.

Any YAML schema that violate this convention at the time of this writing
(e.g. with snake_case keys) may be either grandfathered in, or converted,
at the development team's discretion.

Tests Location
~~~~~~~~~~~~~~
Tests should be in parallel structures to the related code, unless dictated by
target language ecosystem.

For Python projects, the preferred location for tests is a ``tests`` directory
under the directory for the module. E.g. Tests for module foo:
{root}/src/bin/foo/foo/tests.
An alternataive location is ``tests`` at the root of the project, although this
should only be used if there are not multiple components represented in the
same repository, or if the tests cross the components in the repository.

Each type of test should be in its own subdirectory of tests, to allow for easy
separation.  E.g. tests/unit, tests/functional, tests/integration.

Source Code Location
~~~~~~~~~~~~~~~~~~~~
A standard structure for the source code places the source for each module in
a module-named directory under either /src/bin or /src/lib, for executable
modules and shared library modules respectively. Since each module needs its
own setup.py and setup.cfg (python) that lives parallel to the top-level
module (i.e. the package), the directory for the module will contain another
directory named the same.

For example, Project foo, with module foo_service would have a source structure
that is /src/bin/foo_service/foo_service, wherein the __init__.py for the
package resides.

Sample Project Structure (Python)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Project ``foo``, supporting multiple executable modules ``foo_service``,
``foo_cli``, and a shared module ``foo_client`` ::

  {root of foo}
   |- /doc
   |    |- /source
   |    |- requirements.txt
   |- /etc
   |    |- /foo
   |         |- {sample files}
   |- /charts
   |    |- /foo
   |    |- /bar
   |- /images
   |    |- /foo
   |    |    |- Dockerfile
   |    |- /bar
   |         |- Dockerfile
   |- /tools
   |    |- {scripts/utilities supporting build and test}
   |- /src
   |    |- /bin
   |    |    |- /foo_service
   |    |    |    |- /foo_service
   |    |    |    |    |- __init__.py
   |    |    |    |    |- {source directories and files}
   |    |    |    |- /tests
   |    |    |    |    |- unit
   |    |    |    |    |- functional
   |    |    |    |- setup.py
   |    |    |    |- setup.cfg
   |    |    |    |- requirements.txt (and related files)
   |    |    |    |- tox.ini
   |    |    |- /foo_cli
   |    |         |- /foo_cli
   |    |         |    |- __init__.py
   |    |         |    |- {source directories and files}
   |    |         |- /tests
   |    |         |    |- unit
   |    |         |    |- functional
   |    |         |- setup.py
   |    |         |- setup.cfg
   |    |         |- requirements.txt (and related files)
   |    |         |- tox.ini
   |    |- /lib
   |         |- /foo_client
   |              |- /foo_client
   |              |    |- __init__.py
   |              |    |- {source directories and files}
   |              |- /tests
   |              |    |- unit
   |              |    |- functional
   |              |- setup.py
   |              |- setup.cfg
   |              |- requirements.txt (and related files)
   |              |- tox.ini
   |- Makefile
   |- README  (suitable for github consumption)
   |- tox.ini (primarily for the build of repository-level docs)

Note that this is a sample structure, and that target languages may preclude
the location of some items (e.g. tests). For those components with language
or ecosystem standards contrary to this structure, ecosystem convention should
prevail.


.. _Docker: https://www.docker.com/
.. _helm-toolkit: https://git.openstack.org/cgit/openstack/openstack-helm-infra/tree/helm-toolkit
.. _Openstack-Helm: https://wiki.openstack.org/wiki/Openstack-helm
.. _ansible-lint: https://github.com/ansible/ansible-lint
.. _markdownlint: https://github.com/DavidAnson/markdownlint
.. _Shellcheck: https://github.com/koalaman/shellcheck
.. _OCI image annotations standard: https://github.com/opencontainers/image-spec/blob/master/annotations.md#annotations
.. _Airship Multiple Linux Distribution Support: https://airship-specs.readthedocs.io/en/latest/specs/1.x/approved/airship_multi_linux_distros.html#container-builds
.. _example Dockerfile: https://opendev.org/airship/docs/src/branch/master/examples/Dockerfile.opensuse_15
