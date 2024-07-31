return {
  "neovim/nvim-lspconfig",
  dependencies = { "mfussenegger/nvim-jdtls" },
  opts = {
    setup = {
      jdtls = function(_, opts)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "java",
          callback = function()
            ---@diagnostic disable-next-line: undefined-field
            require("lazyvim.util").on_attach(function(_, buffer)
              vim.keymap.set(
                "n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>",
                { buffer = buffer, desc = "Organize Imports" }
              )
              vim.keymap.set(
                "n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>",
                { buffer = buffer, desc = "Test Class" }
              )
              vim.keymap.set(
                "n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
                { buffer = buffer, desc = "Test Nearest Method" }
              )
              vim.keymap.set(
                "v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
                { buffer = buffer, desc = "Extract Variable" }
              )
              vim.keymap.set(
                "n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>",
                { buffer = buffer, desc = "Extract Variable" }
              )
              vim.keymap.set(
                "v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
                { buffer = buffer, desc = "Extract Method" }
              )
              vim.keymap.set(
                "n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>",
                { buffer = buffer, desc = "Format" }
              )
            end)

            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            -- vim.lsp.set_log_level('DEBUG')
            -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
            local workspace_dir = "/home/pbielski/.workspace/" .. project_name

            -- Reference: https://github.com/mfussenegger/nvim-jdtls
            local config = {
              -- Command to start the Java language server
              -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
              cmd = {
                -- "java" or "/path/to/java17_or_newer/bin/java", depends if corret java is at PATH
                "/usr/lib/jvm/java-21-openjdk-amd64/bin/java",
                "-javaagent:/home/pbielski/.local/share/java/lombok.jar",
                -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',

                -- Reference: https://github.com/eclipse-jdtls/eclipse.jdt.ls
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",

                -- Must point to the eclipse.jdt.ls installation (launcher)
                "-jar", "/usr/share/java/jdtls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
                "-configuration", "/usr/share/java/jdtls/org.eclipse.jdt.ls.product/target/repository/config_linux/",

                -- See `data directory configuration` section in the README
                "-data", workspace_dir,
              },

              -- This is the default if not provided, you can remove it. Or adjust as needed.
              -- One dedicated LSP server & client will be started per unique root_dir
              -- root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
              root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

              -- Here you can configure eclipse.jdt.ls specific settings
              -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
              settings = {
                java = {},
              },
              handlers = {
                ["language/status"] = function(_, result)
                  -- print(result)
                end,

                ["$/progress"] = function(_, result, ctx)
                  -- disable progress updates.
                end,
              },
            }
            require("jdtls").start_or_attach(config)
          end,
        })
        return true
      end,
    },
  },
}
