# NUWA.NVIM

![Nuwa.nvim CI](https://github.com/alyxshang/nuwa.nvim/actions/workflows/nvim.yml/badge.svg)

***A light Neovim package manager.***

## ABOUT

This repository contains the Lua source code for an extremely light
package manager for Neovim. The package manager is named after the
Chinese goddess of creation, ***Nuwa (女媧)***.

## FEATURES

- Auto-updates every single plugin as soon as one enters Neovim.
- Auto-updates the package manager as one enters Neovim.
- Allows one to manually delete a plugin with the `NuwaDelete` command.
- Gives the user full control over how one wants to add or install plugins.
- 100% code coverage.
- Extremely light (<200 LOC).

## INSTALLATION

***Nuwa*** requires the `git` command to be available from 
the command line. To install ***Nuwa***, add these lines to 
your `init.lua`, the Lua configuration file for Neovim. It is 
strongly recommended to wrap this snippet into a function and call 
this function before installing a package. The code in this snippet 
will download this repository, place it into Neovim's `data` directory, 
and add the path of the repository to Neovim's runtime path.

```Lua
local nuwaPath = vim.fn.stdpath("data") .. "/nuwa"
vim.fn.system(
  {
    "git", 
    "clone",
    "--branch",
    "v.0.1.0",
    "--depth=1",
    "https://github.com/alyxshang/nuwa.nvim.git",
    nuwaPath
  }
)
vim.opt.rtp:prepend(nuwaPath)
```

## USAGE

The code snippet below illustrates how to load ***Nuwa*** itself,
install a package, and load the package. The section below this code
snippet explains usage of ***Nuwa*** further.

```Lua
-- Declare the "nuwa" module.
local nuwa = require("nuwa")

-- Run the "nuwa" setup
-- function.
nuwa.setup()

-- Install a package.
local someplugin = nuwa.installPackage(
  "https://example.com",
  "someuser",
  "someplugin.nvim"
)

-- Require the installed package
-- and start using it.
require("someplugin").setup({})
```

***Nuwa*** offers the following functions to setup, install, update or
delete plugins. All these functions must be called on a loaded instance of Nuwa. 
In the following list, this instance shall be named `nuwa` for illustrative purposes.

- Installing a package: 
    - `nuwa.installLocal`: This functions returns nothing and expects the absolute path of a plugin saved on disk as an argument.
    - `nuwa.installPackage`: This function expects three arguments: i) the Git hosting provider, ii) the owner of the Git repository containing the package, and iii) the name of the Git repository.
- Updating a package: When Neovim is entered, all packages are updated automatically. This is only done for packages installed from a remote Git repository.
- Removing a package: To remove a package, ***Nuwa*** offers the `NuwaDelete` command. This command expects the name of a package as an argument. This command is only for packages installed from a remote Git repository and is made available as soon as Neovim is entered.
- Updating ***Nuwa***: Nuwa itself is updated when the `setup` function is called on a loaded instance of ***Nuwa***.

## CHANGELOG

### Version 0.1.0

- Initial release.
- Upload to GitHub.

## NOTE

- *Nuwa.nvim* by *Alyx Shang*.
- Licensed under the [FSL v1](https://alyxshang.boo/fair-software-license).
