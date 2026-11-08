return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Dap UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python: the DAP *adapter* process is hosted by a fixed nix store
      -- interpreter that has debugpy installed (flake.nix `dap.pythonAdapter`).
      -- The *debuggee* runs under whatever python3 is active for the
      -- project (a `nix develop`/direnv devShell's interpreter if present,
      -- via VIRTUAL_ENV or PATH) -- it does not need debugpy installed,
      -- since the adapter injects it. This keeps debugging correct whether
      -- the project uses Python 3.8, 3.14, or anything else.
      local dap_python = require("dap-python")
      dap_python.setup(nixCats("dap.pythonAdapter"))

      local function project_python()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and venv ~= "" then
          return venv .. "/bin/python"
        end
        return vim.fn.exepath("python3")
      end

      for _, config in ipairs(dap.configurations.python or {}) do
        config.pythonPath = project_python
      end

      -- Rust / C / C++: lldb-dap (from the nix `lldb` package) as the
      -- DAP server, instead of Mason-managed codelldb.
      local lldb_dap = vim.fn.exepath("lldb-dap")
      if lldb_dap ~= "" then
        dap.adapters.lldb = {
          type = "executable",
          command = lldb_dap,
          name = "lldb",
        }

        local lldb_config = {
          {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }

        dap.configurations.rust = lldb_config
        dap.configurations.c = lldb_config
        dap.configurations.cpp = lldb_config
      end
    end,
  },
}
