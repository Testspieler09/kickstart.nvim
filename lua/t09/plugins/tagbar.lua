return {
  -- NOTE: Tagbar for displaying variable names etc.
  'preservim/tagbar',
  vim.keymap.set('n', '<F8>', vim.cmd.TagbarToggle),
}
