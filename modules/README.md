# Puppet modules

In order to make Puppet modules available for your VMs, it's probably best to set them up as Git submodules. This should be done from the project root.

If, for example, you want to use the [Puppet-network](https://github.com/razorsedge/puppet-network) module, this is the way:

```
#!bash

git submodule add https://github.com/razorsedge/puppet-network.git modules/network

```

Copy the HTTPS clone link of the repository and don't forget to specify the correct subdirectory (`modules/XXXX`).
