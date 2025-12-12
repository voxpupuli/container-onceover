# Vox Pupuli Onceover Container

[![CI](https://github.com/voxpupuli/container-onceover/actions/workflows/ci.yaml/badge.svg)](https://github.com/voxpupuli/container-onceover/actions/workflows/ci.yaml)
[![License](https://img.shields.io/github/license/voxpupuli/container-onceover.svg)](https://github.com/voxpupuli/container-onceover/blob/main/LICENSE)
[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)

## Introduction

This repository contains a containerized version of [Onceover](https://github.com/voxpupuli/onceover) and plugins to facilitate testing OpenVox control repositories.

## Usage

You can run the container using a container runtime like Podman or Docker. Here is an example command to run Onceover in an interactive terminal, mounting the current directory to `/repo` inside the container:

```shell
$ podman run -it --rm -v $PWD:/repo:Z ghcr.io/voxpupuli/onceover:latest

NAME
    onceover - Tool for testing Puppet controlrepos

USAGE
    onceover <subcommand> [options]

COMMANDS
    help       show help
    init       Sets up a controlrepo for testing from scratch
    run        Runs either the spec or acceptance tests
    show       Shows the current state of things
    update     Updates stuff, currently only the Puppetfile

OPTIONS
    -d --debug                           Enable debug logging
       --environment_conf[=<value>]      Location of environment.con
       --environmentpath[=<value>]       Value of environmentpath from
                                         puppet.conf
       --facts_dir[=<value>]             Directory in which to find factsets
       --facts_files[=<value>]           List of factset files to use
                                         (Overrides --facts_dir)
    -h --help                            Show help for this command
       --manifest[=<value>]              Path fo find manifests
       --nodeset_file[=<value>]          YAML file containing node
                                         definitions
       --onceover_yaml[=<value>]         Path of controlrepo.yaml
    -p --path[=<value>]                  Path to the root of the controlrepo
       --puppetfile[=<value>]            Location of the Puppetfile
       --spec_dir[=<value>]              Directory in which to find spec
                                         tests and config
       --tempdir[=<value>]               Temp directory to use, defaults to
                                         .controlrepo
       --trace                           Display stack traces on application
                                         crash
```

For onceover usage have a look at the upstream documentation <https://github.com/voxpupuli/onceover>.

## Versions

To see which tool versions are included in the container see:

[build_versions.yaml](build_versions.yaml)

## How to release?

see [RELEASE.md](RELEASE.md)
