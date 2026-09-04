-- Nuwa.nvim by Alyx Shang.
-- Licensed under the FSL v1.

-- Importing Nuwa to test
-- it.
local nuwa = require("nuwa")

-- Defining the "plenary.nvim"
-- tests.
describe(
  "Testing \"nuwa.nvim\".",
  function()

    -- Testing the "installLocal" function.
    it(
      "Testing the \"installLocal\" function.", 
      function()
        local pkgPath = "/home/test/tester.nvim"
        nuwa.installLocal(pkgPath)
        local rtp_list = vim.opt.runtimepath:get()
        local exists = false
        for _, path in ipairs(rtp_list) do
          if path:gsub("/+$", "") == pkgPath:gsub("/+$", "") then
            exists = true
            break
          end
        end
        assert.is_true(exists)
      end
    )

    -- Testing the "clonePackage" function.
    it(
      "Testing the \"clonePackage\" function.",
      function()
        local host = "https://github.com"
        local pkgOwner = "thesimonho"
        local pkgName = "kanagawa-paper.nvim"
        local handle = nuwa.clonePackage(
          host,
          pkgOwner,
          pkgName
        )
        assert.is_true(handle)
      end
    )

    -- Testing the "installPackage" function.
    it(
      "Testing the \"installPackage\" function.",
      function()
        local host = "https://github.com"
        local pkgOwner = "folke"
        local pkgName = "noice.nvim"
        local handle = nuwa.installPackage(
          host,
          pkgOwner,
          pkgName
        )
        assert.is_true(handle)
      end
    )


    -- Testing the "updatePackage" function.
    it(
      "Testing the \"updatePackage\" function.",
      function()
        local installed = vim.fn.stdpath("data") .. "/nuwa"
        local handle = nuwa.updatePackage(installed)
        assert.is_true(handle)
      end
    )

 
    -- Testing the "setup" function.
    it(
      "Testing the \"setup\" function.",
      function()
        nuwa.setup()
        local nuwaPkgRoot = vim.fn.stdpath("data") .. "/nuwaPkgs"
        local check = vim.loop.fs_stat(nuwaPkgRoot).type == 'directory'
      end
    )

    -- Testing the "delCommand" function.
    it(
      "Testing the \"delCommand\" function.",
      function()
        nuwa.delCommand()
        local commands = vim.api.nvim_get_commands({})
        local exists = commands["NuwaDelete"] ~= nil
        assert.is_true(exists)
      end
    )

  end
)
