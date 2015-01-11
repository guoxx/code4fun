function test1()
    ModuleA = require "ModuleA"
    ModuleA.write("hello world")
end

function test2()
    local function run(filename, env)
        local func, message = loadfile(filename, 't', env)
        if not func then
            print(message)
        end
        return pcall(func)
    end

    local env = {}
    run("GlobalVars.lua", env)
    for k, v in pairs(env) do
        print(k, v)
    end
    print(foo)
    print(bar)
end

arg = ...
_G[arg]()
