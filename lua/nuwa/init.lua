-- Nuwa.nvim by Alyx Shang.
-- Licensed under the FSL v1.

-- Declaring the Nuwa module.
local M = {}

-- A function to emulate
-- a no-op function.
function pass()
end

-- A function to register a command
-- to make it possible for users to
-- delete a package they have installed
-- from a remote Git repository.
M.delCommand = function()
  vim.api.nvim_create_user_command(
    'NuwaDelete',
    function(opts)
      local pkgPath = vim.fn.stdpath("data") .. "/nuwaPkgs/" .. opts.args
      local stat = vim.loop.fs_stat(pkgPath)
      if stat and stat.type == "directory" then
        vim.fn.delete(pkgPath, "rf")
        local pdStat = vim.loop.fs_stat(pkgPath)
        if pdStat and pdStat.type == "directory" then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"The package " .. pkgPath .. " could not be removed!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"The package " .. pkgPath .. " was removed successfully!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        end
      else
        vim.schedule(
          function()
            vim.api.nvim_echo(
              {{"The package " .. pkgPath .. " is not installed!", "Normal"}}, 
              true, 
              {}
            )
          end
        )
      end
    end,
    {
      nargs = 1 
    }
  )
end

-- A function to create the "nuwaPkgs" directory
-- if it doesn't exist already.
M.setup = function(options)
  local nuwaPath = vim.fn.stdpath("data") .. "/nuwa"
  local nuwaPkgRoot = vim.fn.stdpath("data") .. "/nuwaPkgs"
  local check = vim.loop.fs_stat(nuwaPkgRoot)
  if check and check.directory then
    pass()
  else
    vim.fn.mkdir(nuwaPkgRoot, "p")
  end
  M.delCommand()
  M.updatePackage(nuwaPath)
end

-- A function to update a package
-- by pulling the latest changes
-- from the cloned Git repository.
M.updatePackage = function(pkgPath)
  local handle, pid = vim.loop.spawn(
    "git", 
      {
        args = {
          "-C",
          pkgPath,
          "pull"
        }
      },
      function(code, signal)
        if code == 0 then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Updated repository " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Failed to update repository " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        end
      end
    )
    return handle ~= nil
end

-- A function to clone a Git repository
-- into the supplied target directory.
M.clonePackage = function(gitUrl, pkgPath)
  local handle, pid = vim.loop.spawn(
    "git", 
      {
        args = {
	  "clone",
	  "--depth=1", 
	  gitUrl, 
	  pkgPath
	}
      }, 
      function(code, signal)
        if code == 0 then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Cloned " .. gitUrl .. " into " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
	    end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Failed to clone " .. gitUrl .. "!", "Normal"}}, 
                true, 
                {}
              )
	    end
          )
        end
      end
    )
    return handle ~= nil
end

-- A function to install a package given the 
-- package's Git host, owner, and project name.
M.installPackage = function(gitHost, owner, project)
  local pkgPath = vim.fn.stdpath("data") .. "/nuwaPkgs/" .. project
  local gitUrl = ""
  local gitUrl = gitHost .. "/" .. owner .. "/" .. project .. ".git"
  local check = vim.loop.fs_stat(pkgPath)
  vim.opt.rtp:prepend(pkgPath)
  if check and check.type == "directory" then
    return M.updatePackage(pkgPath)
  else
    return M.clonePackage(gitUrl, pkgPath)
  end
end

-- A function to "install" a package
-- saved locally on disk and not
-- hosted in a remote Git repository.
M.installLocal = function(pkgPath)
  vim.opt.rtp:append(pkgPath)
end

-- Exporting the 
-- created module.
return M
