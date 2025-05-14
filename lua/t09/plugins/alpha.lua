vim.api.nvim_set_hl(0, 'Header', { fg = '#33b585', bold = true })
vim.api.nvim_set_hl(0, 'Footer', { fg = '#de9800', bold = true })

local logo = {
  '              Θ      ',
  '              |      ',
  '         _,*/@@@,_   ',
  '       ∙«≡≡≡≡«..»≡≡»∙',
  '          ╟╧╧╧││╧╢   ',
  '        Θ«╟╤╤╤││╤╢»Θ ',
  '    ∙,____╟╧╧╧││╧╢   ',
  '  _,*@@@@@╟╤╤╤││╤╢»Θ ',
  'Θ≈≈≡≡≡≡≡≡≡╟╧╧╧││╧╢   ',
  '   ╟╪╪╪╪╪╡╟╤╤╤││╤╢»Θ ',
  '   ╟╪╪╪╪╪╡╟╧╧╧││╧╢   ',
  ' Θ«╟╧╧╧╧╧╡╟╤╤╤││╤╢»Θ ',
  '   ╟╤╤╤╤╤╡╟╧╧╧││╧╢   ',
  '   ╟╪╪╪╪╪╡╟╤╤╤││╤╢   ',
  '   ╙┴┴┴┴┴┘╙┴┴┴┴┴┴╜   ',
}

local function is_git_project()
  local handle = io.popen 'git rev-parse --is-inside-work-tree 2>/dev/null'
  if handle then
    local result = handle:read '*a'
    handle:close()
    return result:match 'true' ~= nil
  else
    print "Error: Unable to execute 'git rev-parse'."
    return false
  end
end

local function configure()
  local dashboard = require 'alpha.themes.dashboard'

  dashboard.section.header.opts.hl = 'Header'
  dashboard.section.header.val = logo

  -- Set menu
  dashboard.section.buttons.hl = 'Buttons'
  local buttons = {
    type = 'group',
    val = {
      { type = 'text', val = 'File operations', opts = { hl = 'SpecialComment', position = 'center' } },
      dashboard.button('n', '󱪞  => New file', ':ene | startinsert <CR>'),
      dashboard.button('f', '  => Find file', ':Telescope find_files<CR>'),
      dashboard.button('r', '  => Recent', ':Telescope oldfiles<CR>'),
      { type = 'padding', val = 1 },
    },
    position = 'center',
  }

  if is_git_project() then
    table.insert(buttons.val, { type = 'text', val = 'Git commands', opts = { hl = 'SpecialComment', position = 'center' } })
    table.insert(buttons.val, dashboard.button('v', '  => View git status', ':Telescope git_status<CR>'))
    table.insert(buttons.val, dashboard.button('s', '  => Apply stash', ':Telescope git_stash<CR>'))
    table.insert(buttons.val, dashboard.button('b', '  => Switch branch', ':Telescope git_branches<CR>'))
    table.insert(buttons.val, { type = 'padding', val = 1 })
  end

  table.insert(buttons.val, { type = 'text', val = 'System operations', opts = { hl = 'SpecialComment', position = 'center' } })
  table.insert(buttons.val, dashboard.button('q', '󰈆  => Quit NVIM', ':qa<CR>'))

  dashboard.section.footer.opts.hl = 'Footer'
  dashboard.section.footer.val = require 'alpha.fortune'()
  -- dashboard.section.footer.val = '[[-- Fall down seven times, stand up eight --]]'

  local section = dashboard.section
  local fn = vim.fn
  local config = dashboard.config

  local marginTopPercent = 0.3
  local headerPadding = fn.max { 2, fn.floor(fn.winheight(0) * marginTopPercent) }

  config.layout = {
    { type = 'padding', val = headerPadding },
    section.header,
    { type = 'padding', val = 1 },
    buttons,
    { type = 'padding', val = 2 },
    section.footer,
  }

  return config
end

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    require('alpha').setup(configure())
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}
