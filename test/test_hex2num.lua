local current_dir = vim.fn.getcwd()
-- Configurar package.path para incluir la carpeta lua
package.path = package.path .. ";" .. current_dir .. "/lua/?.lua"
local hex = "0xa5"

print(vim.fn.str2nr(hex, 16))
print(vim.fn.str2nr("165", 10))
print(vim.fn.str2nr("101", 2))

binary = require("binary-nvim")

print(binary.get_number("10"))
