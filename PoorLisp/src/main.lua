require "helper"
require "interpreter"

args = {...}
function _is_opt(_, v)
    return string.idx(v, 1) == "-"
end

srcs = table.ifilter(args, function (_, v) return not _is_opt(_, v) end)
opts = table.ifilter(args, _is_opt)

for i, v in ipairs(srcs or {}) do
    local verbose = table.contain(opts, "-v")
    interp(v, verbose)
end
