return
{
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "abayomi185/nvim-dap-probe-rs",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})
      require('dap-probe-rs').setup()

      -- Adapters
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/thegeneralist/.cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }
      dap.adapters.gdb = {
        type = "executable",
        id = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }
      dap.adapters["probe-rs-debug"] = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
          args = { "dap-server", "--port", "${port}" },
        },
      }

      -- RUST
      dap.adapters["probe-rs-debug"] = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
          args = { "dap-server", "--port", "${port}" },
        },
      }
      -- Connect the probe-rs-debug with rust files. Configuration of the debugger is done via project_folder/.vscode/launch.json
      require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust" }
      -- Set up of handlers for RTT and probe-rs messages.
      -- In addition to nvim-dap-ui I write messages to a probe-rs.log in project folder
      -- If RTT is enabled, probe-rs sends an event after init of a channel. This has to be confirmed or otherwise probe-rs wont sent the rtt data.
      dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
        local utils = require "dap.utils"
        utils.notify(
          string.format('probe-rs: Opening RTT channel %d with name "%s"!', body.channelNumber, body.channelName)
        )
        local file = io.open("probe-rs.log", "a")
        if file then
          file:write(
            string.format(
              '%s: Opening RTT channel %d with name "%s"!\n',
              os.date "%Y-%m-%d-T%H:%M:%S",
              body.channelNumber,
              body.channelName
            )
          )
        end
        if file then file:close() end
        session:request("rttWindowOpened", { body.channelNumber, true })
      end
      -- After confirming RTT window is open, we will get rtt-data-events.
      -- I print them to the dap-repl, which is one way and not separated.
      -- If you have better ideas, let me know.
      dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
        local message =
            string.format("%s: RTT-Channel %d - Message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.channelNumber, body
              .data)
        local repl = require "dap.repl"
        repl.append(message)
        local file = io.open("probe-rs.log", "a")
        if file then file:write(message) end
        if file then file:close() end
      end
      -- Probe-rs can send messages, which are handled with this listener.
      dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
        local message = string.format("%s: probe-rs message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.message)
        local repl = require "dap.repl"
        repl.append(message)
        local file = io.open("probe-rs.log", "a")
        if file then file:write(message) end
        if file then file:close() end
      end
      -- RUST END

      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Select and attach to process",
          type = "gdb",
          request = "attach",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input('Executable name (filter): ')
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = '${workspaceFolder}'
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}'
        },
      }



      -- Configurations
      -- dap.configurations.cpp = {
      --   {
      --     name = "Launch file",
      --     type = "cppdbg",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      --     end,
      --     cwd = "${workspaceFolder}",
      --     stopAtEntry = true,
      --     setupCommands = {
      --       {
      --         text = "-enable-pretty-printing",
      --         description = "enable pretty printing",
      --         ignoreFailures = false,
      --       },
      --     },
      --   },
      --   {
      --     name = "Attach to gdbserver :1234",
      --     type = "cppdbg",
      --     request = "launch",
      --     MIMode = "gdb",
      --     miDebuggerServerAddress = "localhost:1234",
      --     miDebuggerPath = "/usr/bin/gdb",
      --     cwd = "${workspaceFolder}",
      --     program = function()
      --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      --     end,
      --     setupCommands = {
      --       {
      --         text = "-enable-pretty-printing",
      --         description = "enable pretty printing",
      --         ignoreFailures = false,
      --       },
      --     },
      --   },
      -- }


      dap.configurations.cpp = dap.configurations.c
      require("dap-python").setup("python")

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>guo", ui.open)
      vim.keymap.set("n", "<leader>guc", ui.close)

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        ui.eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F6>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      -- 	ui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      -- 	-- ui.close()
      -- end
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  }
}
