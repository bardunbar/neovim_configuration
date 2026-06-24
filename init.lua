-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Rust Tools Setup
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, buf)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = buf })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = buf })
    end,
  },
})

-- Godot Project Setup
do
  -- Paths to check for Godot Project
  local paths_to_check = { "/", "/../" }
  local is_godot_project = false
  local godot_project_path = ""
  local cwd = vim.fn.getcwd()

  -- look for the project file
  for _, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. "project.godot") then
      is_godot_project = true
      godot_project_path = cwd .. value
      print("Found godot: " .. godot_project_path)
      break
    end
  end

  -- Check if the server is running
  local is_server_running = false --vim.uv.fs_stat(godot_project_path .. "server.pipe")
  -- start the server if needed
  if is_godot_project and not is_server_running then
    --vim.fn.serverstart(godot_project_path .. "server.pipe")
    vim.fn.serverstart("localhost:8765")
  end

  --local running_servers = vim.fn.serverlist()

  if is_godot_project then
    vim.cmd('let NERDTreeIgnore = ["\\.uid$"]')
  end

  vim.lsp.config("gdscript", {})
  vim.lsp.enable("gdscript")
end

vim.lsp.enable("codebook")

vim.diagnostic.config({ virtual_text = true, virtual_lines = { current_line = true } })

vim.opt.shell = "pwsh"
vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
