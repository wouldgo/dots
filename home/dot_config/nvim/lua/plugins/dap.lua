local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

-- cargo build, then the binary to debug: picked from a list when the
-- workspace builds more than one
local function cargo_program()
  local dap = require("dap")
  vim.notify("cargo build...")
  local result = vim.system({ "cargo", "build", "--message-format=json" }, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify("cargo build failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
    return dap.ABORT
  end

  local binaries = {}
  for line in result.stdout:gmatch("[^\n]+") do
    local ok, msg = pcall(vim.json.decode, line)
    if ok and msg.reason == "compiler-artifact" and msg.executable ~= vim.NIL and msg.executable then
      table.insert(binaries, msg.executable)
    end
  end
  if #binaries == 0 then
    vim.notify("cargo build produced no binary", vim.log.levels.ERROR)
    return dap.ABORT
  elseif #binaries == 1 then
    return binaries[1]
  end

  local co = coroutine.running()
  vim.ui.select(binaries, { prompt = "Binary to debug" }, function(choice)
    coroutine.resume(co, choice or dap.ABORT)
  end)
  return coroutine.yield()
end

local function prompt_args()
  return vim.split(vim.fn.input("Arguments: "), " +", { trimempty = true })
end

return {
  "mfussenegger/nvim-dap",
  -- Loaded by the debug keybindings in config/keymaps.lua
  lazy = true,
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
    "mason-org/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup({})
    -- Like VSCode: the debug views open with the session and stay after it
    -- ends, so the output can still be read; Ctrl+Shift+D closes them
    dap.listeners.after.event_initialized.dapui = function()
      dapui.open()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", linehl = "Visual" })

    -- Go: delve, with the same build tags as go.testTags in VSCode
    require("dap-go").setup({ delve = { build_flags = "-tags=test" } })

    -- Rust: codelldb, the adapter of the CodeLLDB extension ("type": "lldb"
    -- in its launch.json)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    }
    dap.adapters.lldb = dap.adapters.codelldb
    dap.configurations.rust = {
      {
        name = "Launch (cargo build)",
        type = "codelldb",
        request = "launch",
        program = cargo_program,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Launch with arguments (cargo build)",
        type = "codelldb",
        request = "launch",
        program = cargo_program,
        args = prompt_args,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
      },
    }

    -- JavaScript/TypeScript: vscode-js-debug, the debugger built into VSCode.
    -- "node" and "chrome" in a launch.json are its "pwa-" types.
    local js_debug = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = "js-debug-adapter", args = { "${port}" } },
    }
    for _, kind in ipairs({ "node", "chrome" }) do
      dap.adapters["pwa-" .. kind] = js_debug
      dap.adapters[kind] = vim.tbl_extend("force", js_debug, {
        enrich_config = function(config, on_config)
          on_config(vim.tbl_extend("force", config, { type = "pwa-" .. kind }))
        end,
      })
    end
    for _, ft in ipairs(js_filetypes) do
      dap.configurations[ft] = {
        {
          -- Recent Node versions run .ts files directly
          name = "Launch current file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        },
        {
          name = "Attach to process",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        },
      }
    end

    -- ESP32 over the serial port, with no JTAG probe: see lua/esp_idf.lua.
    -- Two hardware breakpoints at most, and the monitor cannot use the port
    -- at the same time.
    dap.adapters.cppdbg = { id = "cppdbg", type = "executable", command = "OpenDebugAD7" }
    dap.providers.configs["esp-idf"] = require("esp_idf").dap_configurations

    -- .vscode/launch.json is read on every F5: these types tell which
    -- filetypes its configurations belong to
    local vscode = require("dap.ext.vscode")
    -- VSCode accepts trailing commas in launch.json, vim.json does not
    vscode.json_decode = function(str, opts)
      return vim.json.decode((str:gsub(",%s*([%]}])", "%1")), opts)
    end
    vscode.type_to_filetypes.node = js_filetypes
    vscode.type_to_filetypes["pwa-node"] = js_filetypes
    vscode.type_to_filetypes.chrome = js_filetypes
    vscode.type_to_filetypes["pwa-chrome"] = js_filetypes
    vscode.type_to_filetypes.lldb = { "rust", "c", "cpp" }
    vscode.type_to_filetypes.codelldb = { "rust", "c", "cpp" }
  end,
}
