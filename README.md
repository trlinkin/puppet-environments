# Puppet Environments repo #

This repository contains Puppet environment definitions, one per Yaml file.
Each definition includes:

* The base environment content—source and version of Puppet code from a control
  repository, deployed to the basedir of the environment.
* Optionally, a hash of module definitions. The module defintions follow the
  same convention as `mod` statements in a Puppetfile.

R10k is configured to use this repo as a `puppet_environment_repo`-type
source, tracking the master branch. (Note that this is a different source type
from `git` or `svn`, which are based on branches). When running `puppet code
deploy <environment>`, r10k will fetch the head of this repo, read the
environment defintion files found there, and perform deployment of them as
requested.

Any modules defined directly in the environment defintion Yaml file will be
deployed first. If the Puppetfile in the base code contains a conflicting
module definition, an error will be raised. Provided there are no conflicts
both the environment definition Yaml file and the Puppetfile from the base
source may add modules to the environment.
