function old()
    return {
        cons = function(v1, v2)
            return {v1, v2}
        end,
        car = function(v)
            return v[1]
        end,
        cdr = function(v)
            return v[2]
        end
    }
end

function new()
    return {
        cons = function(v1, v2)
            return function()
                return v1, v2
            end
        end,
        car = function(v)
            local ret, _ = v()
            return ret
        end,
        cdr = function(v)
            local _, ret = v()
            return ret
        end
    }
end

local arg = ...
local collectgarbage = collectgarbage
local clock = os.clock
local print = print

_ENV = _G[arg]()

collectgarbage("stop")
local mem = collectgarbage("count")
local ti = clock()

for i = 1, 1000 do
    local v = cons(cons("a", "b"), "c")
    for j = 1, 1000 do
        local v1 = car(v)
        local v2 = cdr(v) 
    end
end

print("time: ", clock() - ti)
print("mem: ", collectgarbage("count") - mem)