-- VSCode keybindings on top of the Vim modes.
--
-- Combinations like Ctrl+Shift+P, Ctrl+. or Shift+F5 reach nvim only when the
-- terminal reports them unambiguously (kitty protocol in Alacritty, extended
-- keys in tmux). Shifted/ctrl F-keys are also mapped by their legacy names
-- (Shift+F5 = F17, Ctrl+F5 = F29, Ctrl+Shift+F5 = F41).

-- lhs may be a list, for keys known by more than one name
local function map(modes, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
  for _, key in ipairs(type(lhs) == "table" and lhs or { lhs }) do
    for _, mode in ipairs(type(modes) == "table" and modes or { modes }) do
      if mode == "v" and type(rhs) == "string" then
        vim.keymap.set("x", key, rhs, opts)
        -- In Select mode (Shift+arrows) the keys of rhs would be typed over the
        -- selection: Ctrl+G switches to Visual mode first
        vim.keymap.set("s", key, "<C-g>" .. rhs, opts)
      else
        vim.keymap.set(mode, key, rhs, opts)
      end
    end
  end
end

local function save()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd.write()
    return
  end
  vim.ui.input({ prompt = "Save as: ", completion = "file" }, function(path)
    if path and path ~= "" then
      vim.cmd.saveas(vim.fn.fnameescape(path))
    end
  end)
end

local picker = function(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

local dap = function(fn, ...)
  local args = { ... }
  return function()
    require("dap")[fn](unpack(args))
  end
end

-- Files and editors ----------------------------------------------------------

-- :q closes the file like Ctrl+W, and nvim only with the last file. It acts on
-- the editor also from the explorer or the other side windows (Ctrl+B closes
-- the explorer). A split window is closed as usual; :q! keeps the Vim meaning.
vim.api.nvim_create_user_command("CloseFile", function()
  local files = vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.api.nvim_win_get_config(win).relative == "" and vim.bo[buf].buftype == ""
  end, vim.api.nvim_tabpage_list_wins(0))
  if vim.bo.buftype ~= "" and #files > 0 then
    local previous = vim.fn.win_getid(vim.fn.winnr("#"))
    vim.api.nvim_set_current_win(vim.tbl_contains(files, previous) and previous or files[1])
  end
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if vim.bo.buflisted and vim.bo.buftype == "" and #files == 1 and #listed > 1 then
    Snacks.bufdelete()
  else
    vim.cmd("confirm quit")
  end
end, { desc = "Close the file, or nvim with the last one" })
-- Replaced on Enter, only when the whole line is the command: what you type is
-- never rewritten, and :q!, :qa, :wq file keep their Vim meaning
local close_file = { q = "CloseFile", quit = "CloseFile", wq = "write | CloseFile", x = "update | CloseFile" }
vim.keymap.set("c", "<CR>", function()
  local line = vim.fn.getcmdtype() == ":" and close_file[vim.trim(vim.fn.getcmdline())]
  if line then
    vim.fn.setcmdline(line)
  end
  return "<CR>"
end, { expr = true, desc = "Run the command (:q closes the file)" })

map({ "n", "i", "v" }, "<C-s>", save, "Save")
map({ "n", "i", "v" }, "<C-w>", function()
  Snacks.bufdelete()
end, "Close editor")
map({ "n", "i" }, "<C-n>", "<Cmd>enew<CR>", "New file")
map({ "n", "i" }, "<C-p>", picker("smart"), "Go to file")
map({ "n", "i" }, "<C-o>", picker("files"), "Open file")
map({ "n", "i" }, "<C-r>", picker("recent"), "Open recent")
map({ "n", "i" }, { "<C-S-p>", "<F1>" }, picker("commands"), "Command palette")
map("n", "<C-k><C-s>", picker("keymaps"), "Keyboard shortcuts")
map({ "n", "i" }, { "<C-Tab>", "<C-PageDown>" }, "<Cmd>BufferLineCycleNext<CR>", "Next editor")
map({ "n", "i" }, { "<C-S-Tab>", "<C-PageUp>" }, "<Cmd>BufferLineCyclePrev<CR>", "Previous editor")
for i = 1, 9 do
  map({ "n", "i" }, "<M-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", "Editor " .. i)
end

-- Views
map({ "n", "i" }, { "<C-b>", "<C-S-e>" }, function()
  Snacks.explorer()
end, "Explorer")
local function terminal()
  Snacks.terminal()
end
map({ "n", "i", "t" }, "<C-`>", terminal, "Terminal")
-- Not in terminal mode: shells and fzf use Ctrl+J
map({ "n", "i" }, "<C-j>", terminal, "Terminal")
map({ "n", "i" }, "<C-S-m>", picker("diagnostics"), "Problems")
map({ "n", "i" }, "<C-S-g>", picker("git_status"), "Source control")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- Navigation -----------------------------------------------------------------

-- The jumplist: Alt+Left goes back, Alt+Right forward again. Like VSCode it
-- skips the places that are gone (lines deleted, file changed outside), where
-- Ctrl+O/Ctrl+I stop with E19. A closed file is fine: the jump opens it again.
local function jump(step)
  local list, current = unpack(vim.fn.getjumplist())
  local wanted, count, i = vim.v.count1, 0, current
  while wanted > 0 do
    i = i + step
    local entry = list[i + 1]
    if not entry then
      return
    end
    count = count + 1
    local buf = entry.bufnr
    local gone = not vim.api.nvim_buf_is_valid(buf)
      or (vim.api.nvim_buf_is_loaded(buf) and entry.lnum > vim.api.nvim_buf_line_count(buf))
    if not gone then
      wanted = wanted - 1
    end
  end
  -- The count also keeps :normal from dropping a leading Tab (Ctrl+I)
  local ok, err = pcall(vim.cmd, "normal! " .. count .. (step < 0 and "\15" or "\t"))
  if not ok then
    vim.notify(err:match("E%d+:.*") or err, vim.log.levels.WARN)
  end
end
map({ "n", "i" }, "<M-Left>", function()
  jump(-1)
end, "Go back")
map({ "n", "i" }, "<M-Right>", function()
  jump(1)
end, "Go forward")
map({ "n", "i" }, "<C-g>", "<Esc>:", "Go to line", { silent = false })
map({ "n", "i" }, "<C-S-o>", picker("lsp_symbols"), "Go to symbol in editor")
map({ "n", "i" }, "<C-t>", picker("lsp_workspace_symbols"), "Go to symbol in workspace")
map({ "n", "i" }, "<F8>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next problem")
map({ "n", "i" }, { "<S-F8>", "<F20>" }, function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous problem")

-- Code (LSP) -----------------------------------------------------------------

map({ "n", "i" }, "<F12>", picker("lsp_definitions"), "Go to definition")
map({ "n", "i" }, { "<S-F12>", "<F24>" }, picker("lsp_references"), "Go to references")
map({ "n", "i" }, { "<C-F12>", "<F36>" }, picker("lsp_implementations"), "Go to implementation")
map({ "n", "i" }, "<F2>", vim.lsp.buf.rename, "Rename symbol")
map({ "n", "i", "v" }, "<C-.>", vim.lsp.buf.code_action, "Quick fix")
map("n", { "<C-k><C-i>", "<C-k><Tab>" }, vim.lsp.buf.hover, "Show hover")
map({ "n", "i" }, "<C-S-Space>", vim.lsp.buf.signature_help, "Parameter hints")
map({ "n", "i", "v" }, { "<M-S-f>", "<M-F>" }, function()
  require("conform").format({ async = true })
end, "Format document")

-- Editing ----------------------------------------------------------------------

map("n", "<C-z>", "u", "Undo")
map("i", "<C-z>", "<C-o>u", "Undo")
map("v", "<C-z>", "<Esc>u", "Undo")
map("n", { "<C-y>", "<C-S-z>" }, "<C-r>", "Redo")
map("i", { "<C-y>", "<C-S-z>" }, "<C-o><C-r>", "Redo")

-- Without a selection Ctrl+C/Ctrl+X work on the whole line, as in VSCode
map("v", "<C-c>", "y", "Copy")
map("n", "<C-c>", "yy", "Copy line")
map("i", "<C-c>", "<Cmd>normal! yy<CR>", "Copy line")
map("v", "<C-x>", "d", "Cut")
map("n", "<C-x>", "dd", "Cut line")
map("i", "<C-x>", "<Cmd>normal! dd<CR>", "Cut line")
map("n", "<C-v>", "P", "Paste")
map("v", "<C-v>", '"_dP', "Paste")
map("i", "<C-v>", "<C-r><C-o>+", "Paste")

map({ "n", "i" }, "<C-S-k>", '<Cmd>normal! "_dd<CR>', "Delete line")
map("v", "<C-S-k>", '"_d', "Delete line")
map("n", "<C-CR>", "o", "Insert line below")
map("i", "<C-CR>", "<C-o>o", "Insert line below")
map("n", "<C-S-CR>", "O", "Insert line above")
map("i", "<C-S-CR>", "<C-o>O", "Insert line above")
map("n", "<C-l>", "V", "Select line")
map("v", "<C-l>", "j", "Expand line selection")
map("i", "<C-BS>", "<C-w>", "Delete word left")

-- Ctrl+Up/Down move lines (your VSCode override of the default Alt+Up/Down)
map("n", "<C-Up>", "<Cmd>move .-2<CR>", "Move line up")
map("n", "<C-Down>", "<Cmd>move .+1<CR>", "Move line down")
map("i", "<C-Up>", "<Cmd>move .-2<CR>", "Move line up")
map("i", "<C-Down>", "<Cmd>move .+1<CR>", "Move line down")
map("v", "<C-Up>", ":move '<-2<CR>gv", "Move lines up")
map("v", "<C-Down>", ":move '>+1<CR>gv", "Move lines down")
map({ "n", "i" }, { "<M-S-Down>", "<C-M-S-Down>" }, "<Cmd>copy .<CR>", "Copy line down")
map({ "n", "i" }, { "<M-S-Up>", "<C-M-S-Up>" }, "<Cmd>copy .-1<CR>", "Copy line up")

-- Alt+Up/Down expand/shrink the selection (treesitter nodes, LSP as fallback)
map("n", "<M-Up>", "van", "Expand selection", { remap = true })
map("x", "<M-Up>", "an", "Expand selection", { remap = true })
map("x", "<M-Down>", "in", "Shrink selection", { remap = true })

map("n", { "<C-/>", "<C-_>" }, "gcc", "Toggle line comment", { remap = true })
map("i", { "<C-/>", "<C-_>" }, "<Cmd>normal gcc<CR>", "Toggle line comment")
map("x", { "<C-/>", "<C-_>" }, "gc", "Toggle line comment", { remap = true })

map("x", "<Tab>", ">gv", "Indent")
map("x", "<S-Tab>", "<gv", "Outdent")

-- Search -----------------------------------------------------------------------

map("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", "Clear search highlight")
map("n", "<C-f>", "/", "Find", { silent = false })
map("i", "<C-f>", "<Esc>/", "Find", { silent = false })
map({ "n", "i" }, "<F3>", "<Cmd>normal! n<CR>", "Find next")
map({ "n", "i" }, { "<S-F3>", "<F15>" }, "<Cmd>normal! N<CR>", "Find previous")
map("n", "<C-h>", [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]], "Replace", { silent = false })
map("x", "<C-h>", [["zy:%s/\V<C-r>z//gc<Left><Left><Left>]], "Replace", { silent = false })
map({ "n", "i" }, "<C-S-f>", picker("grep"), "Search in files")
map("x", "<C-S-f>", picker("grep_word"), "Search selection in files")
map({ "n", "i", "v" }, "<C-S-h>", "<Cmd>GrugFar<CR>", "Replace in files")

-- Debug ------------------------------------------------------------------------

map({ "n", "i" }, "<F5>", dap("continue"), "Debug: start/continue")
map({ "n", "i" }, { "<S-F5>", "<F17>" }, dap("terminate"), "Debug: stop")
map({ "n", "i" }, { "<C-S-F5>", "<F41>" }, dap("restart"), "Debug: restart")
map({ "n", "i" }, "<F6>", dap("pause"), "Debug: pause")
map({ "n", "i" }, "<F9>", dap("toggle_breakpoint"), "Debug: toggle breakpoint")
map({ "n", "i" }, "<F10>", dap("step_over"), "Debug: step over")
map({ "n", "i" }, "<F11>", dap("step_into"), "Debug: step into")
map({ "n", "i" }, { "<S-F11>", "<F23>" }, dap("step_out"), "Debug: step out")
map({ "n", "i" }, { "<C-F10>", "<F34>" }, dap("run_to_cursor"), "Debug: run to cursor")
map({ "n", "i" }, "<C-S-d>", function()
  require("dapui").toggle()
end, "Debug: views")

local function conditional_breakpoint()
  vim.ui.input({ prompt = "Condition: " }, function(condition)
    if condition and condition ~= "" then
      require("dap").set_breakpoint(condition)
    end
  end)
end
local function logpoint()
  vim.ui.input({ prompt = "Log message ({expression} is interpolated): " }, function(message)
    if message and message ~= "" then
      require("dap").set_breakpoint(nil, nil, message)
    end
  end)
end

map({ "n", "i" }, { "<S-F9>", "<F21>" }, conditional_breakpoint, "Debug: conditional breakpoint")
map("n", "<leader>db", dap("toggle_breakpoint"), "Toggle breakpoint")
map("n", "<leader>dB", conditional_breakpoint, "Conditional breakpoint")
map("n", "<leader>dl", logpoint, "Logpoint")
map("n", "<leader>dx", dap("clear_breakpoints"), "Remove all breakpoints")
map("n", "<leader>dr", function()
  require("dap").repl.toggle()
end, "Debug console")
map({ "n", "x" }, "<leader>de", function()
  require("dapui").eval()
end, "Evaluate expression")
map("n", "<leader>du", function()
  require("dapui").toggle()
end, "Debug views")

-- Git ----------------------------------------------------------------------------

map("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>", "Blame line")
map("n", "<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", "Preview change")
map("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Revert change")
map("n", "]h", "<Cmd>Gitsigns next_hunk<CR>", "Next change")
map("n", "[h", "<Cmd>Gitsigns prev_hunk<CR>", "Previous change")
