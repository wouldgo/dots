-- ESP-IDF projects: serial port, debug firmware and its debug configuration.
--
-- The debug firmware has the GDB stub on the serial port (no JTAG probe
-- needed). It is built next to the normal one, out of the project, so no
-- debug setting can end up in the project or in its git history.

local M = {}

local files = vim.fn.stdpath("config") .. "/esp-idf"

local function read_json(path)
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  return ok and data or nil
end

-- An ESP-IDF project has sdkconfig
function M.root(buf)
  return vim.fs.root(buf or 0, "sdkconfig")
end

function M.debug_build_dir(root)
  return vim.fn.stdpath("cache") .. "/esp-idf-debug" .. root
end

-- idf.py writes the elf, the gdb prefix and the baud in
-- project_description.json: the debug build wins when there is one
function M.project(buf)
  local root = M.root(buf)
  if not root then
    return
  end
  for _, dir in ipairs({ M.debug_build_dir(root), root .. "/build" }) do
    local desc = read_json(dir .. "/project_description.json")
    if desc then
      return root, desc
    end
  end
end

-- ESPPORT as for idf.py, then the port of the VSCode extension, then the only
-- serial adapter connected, otherwise a list. Runs in a coroutine.
function M.port(root)
  local settings = read_json(root .. "/.vscode/settings.json") or {}
  local port = vim.env.ESPPORT or settings["idf.port"]
  if port then
    return port
  end
  local ports = vim.list_extend(vim.fn.glob("/dev/ttyUSB*", false, true), vim.fn.glob("/dev/ttyACM*", false, true))
  if #ports <= 1 then
    return ports[1]
  end
  local co = coroutine.running()
  vim.ui.select(ports, { prompt = "Serial port" }, function(choice)
    coroutine.resume(co, choice)
  end)
  return coroutine.yield()
end

function M.gdb(prefix)
  local found = vim.fn.glob(vim.fs.normalize("~/.espressif/tools") .. "/*-gdb/*/*/bin/" .. prefix .. "gdb", false, true)
  table.sort(found)
  return found[#found] or (prefix .. "gdb")
end

-- The firmware to debug must carry the GDB stub without the FreeRTOS task
-- list: cpptools fails on it ("Failed to find thread 1 for break event")
function M.has_stub(desc)
  local ok, lines = pcall(vim.fn.readfile, desc.config_file)
  local config = ok and table.concat(lines, "\n") or ""
  return config:find("\nCONFIG_ESP_SYSTEM_GDBSTUB_RUNTIME=y") ~= nil
    and not config:find("\nCONFIG_ESP_GDBSTUB_SUPPORT_TASKS=y")
end

-- The idf.py command of the debug build. The IDF is the one that built the
-- project (build/project_description.json), else IDF_PATH. The sdkconfig of
-- the project is the starting point, sdkconfig.debug goes on top; the debug
-- sdkconfig is made again when the one of the project changes.
function M.debug_command(root, port)
  local built = read_json(root .. "/build/project_description.json") or {}
  local idf = built.idf_path or vim.env.IDF_PATH
  if not idf then
    return nil, "No ESP-IDF: build the project once with idf.py, or set IDF_PATH"
  end
  local script = table.concat({
    "set -e",
    '. "$IDF/export.sh" > /dev/null',
    '[ "$ROOT/sdkconfig" -nt "$BUILD/sdkconfig" ] && rm -f "$BUILD/sdkconfig"',
    'export SDKCONFIG_DEFAULTS="$ROOT/sdkconfig;$FILES/sdkconfig.debug"',
    'idf.py -C "$ROOT" -B "$BUILD" -D SDKCONFIG="$BUILD/sdkconfig" -D CMAKE_PROJECT_INCLUDE="$FILES/debug.cmake" '
      .. (port and '-p "$PORT" build flash' or "build"),
  }, "\n")
  local env = { IDF = idf, ROOT = root, BUILD = M.debug_build_dir(root), FILES = files, PORT = port }
  return { "bash", "-c", script }, env
end

-- Space d f: build the debug firmware and flash it, in a terminal
function M.debug_firmware()
  local root = M.root()
  if not root then
    vim.notify("Not in an ESP-IDF project (no sdkconfig)", vim.log.levels.WARN)
    return
  end
  coroutine.wrap(function()
    local port = M.port(root)
    if not port then
      vim.notify("No serial port: connect the board or set ESPPORT", vim.log.levels.ERROR)
      return
    end
    local cmd, env = M.debug_command(root, port)
    if not cmd then
      vim.notify(env, vim.log.levels.ERROR)
      return
    end
    Snacks.terminal(cmd, { cwd = root, env = env, auto_close = false })
  end)()
end

-- F5 > "ESP-IDF: debug over the serial port", added to the configurations
-- of the ESP-IDF projects. cpptools drives the Espressif gdb, which has no
-- Python and so no built-in DAP.
function M.dap_configurations(buf)
  local root, desc = M.project(buf)
  if not root then
    return {}
  end
  local dap = require("dap")
  return {
    {
      name = "ESP-IDF: debug over the serial port (GDB stub)",
      type = "cppdbg",
      request = "launch",
      MIMode = "gdb",
      miDebuggerPath = M.gdb(desc.monitor_toolprefix),
      miDebuggerServerAddress = function()
        return M.port(root) or dap.ABORT
      end,
      program = function()
        if not M.has_stub(desc) then
          vim.notify("No debug firmware: build and flash it with Space d f", vim.log.levels.ERROR)
          return dap.ABORT
        end
        return desc.build_dir .. "/" .. desc.app_elf
      end,
      cwd = root,
      setupCommands = {
        { text = "set serial baud " .. desc.monitor_baud },
        { text = "set remotetimeout 10" },
        -- The stub resumes on c, not on C with a signal
        { text = "handle all nopass" },
      },
    },
  }
end

return M
