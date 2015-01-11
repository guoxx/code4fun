local print = print

local M = {}

_ENV = M

function write(...)
    print(...)
end

return M
