require "helper"
require "parser"

local global_env = nil

function init_env()
    return {}
end

function extend_env(orig)
    local env = {}
    setmetatable(env, {__index = orig})
    return env
end

function apply_env(env, var)
    return env[var]
end

function update_env(env, var, val)
    env[var] = val
    return true
end

function read(filename)
    local file = io.open(filename, "r")
    local txt = file:read("*a")

    local expressions = {}
    for i, e in ipairs(parse(txt) or {}) do
        table.insert(expressions, e)
    end
    -- table.deep_print(expr)
    return expressions
end

function is_true(v)
    return not not v
end

function is_num(expr)
    return tonumber(expr) ~= nil
end

function is_str(expr)
    return type(expr) == "string" and string.idx(expr, 1) == "\""
end

function is_bool(expr)
    return expr == "true" or expr == "false"
end

function is_sym(expr)
    return type(expr) == "string" and (not is_num(expr)) and (not is_str(expr)) and (not is_bool(expr))
end

function is_compound_expr(expr)
    return type(expr) == "table"
end

function is_proc(expr)
    return type(expr) == "table" and expr[1] == "proc"
end

function expr_val(expr)
    if is_num(expr) then
        return tonumber(expr)
    elseif is_str(expr) then
        return expr
    elseif is_sym(expr) then
        return expr
    elseif is_bool(expr) then
        if expr == "true" then
            return true
        elseif expr == "false" then
            return false
        end
    else
        return expr
    end
end

function apply(operator, operands, env)
    if is_sym(operator) then
        if operator == "+" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return table.accumulate(params, function(v, t) return t + v end, 0)
        elseif operator == "-" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return table.accumulate(params, function(v, t) return t - v end, params[1] * 2)
        elseif operator == "*" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return table.accumulate(params, function(v, t) return t * v end, 1)
        elseif operator == "/" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return table.accumulate(params, function(v, t) return t / v end, params[1] * params[1])
        elseif operator == "=" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return params[1] == params[2]
        elseif operator == "<" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return params[1] < params[2]
        elseif operator == ">" then
            local params = table.map(operands, function(_, v) return eval(v, env) end)
            return params[1] > params[2]            
        elseif operator == "odd?" then
            return math.fmod(eval(operands[1], env), 2) ~= 0
        elseif operator == "begin" then
            local ret = nil
            local newenv = extend_env(env)
            for _, v in ipairs(operands) do
                ret = eval(v, newenv)
            end
            return ret
        elseif operator == "define" then
            local var = assert(operands[1])
            local val = eval(assert(operands[2]), extend_env(env))
            return update_env(env, var, val)
        elseif operator == "lambda" then
            local proc = {"proc"}
            table.insert(proc, operands[1])
            table.insert(proc, operands[2])
            table.insert(proc, env)
            return proc
        elseif operator == "if" then
            local predicate = assert(operands[1])
            local consequent = assert(operands[2])
            local alternative = assert(operands[3])
            if is_true(eval(predicate, env)) then
                return eval(consequent, env)
            else
                return eval(alternative, env)
            end
        elseif operator == "print" then
            for _, v in ipairs(operands) do
                print(eval(v, env))
            end
            return true
        else
            local expr = apply_env(env, operator)
            if expr ~= nil then
                local tbl = {eval(expr, env)}
                for i, v in ipairs(operands) do
                    table.insert(tbl, v)
                end
                return eval(tbl, extend_env(env))
            else
                 print(operator)
                 table.deep_print(operands)
                 assert(false, "unknow symbol " .. operator)
                 return false
             end
        end
    else
        if is_proc(operator) then
            local expr = operator
            local params_list = expr[2]
            local expression = expr[3]
            local newenv = extend_env(expr[4])
            for i, k in ipairs(params_list) do
                local param = eval(operands[i], env)
                assert(is_sym(k))
                update_env(newenv, expr_val(k), param)
            end
            return eval(expression, newenv)
        else
            assert(type(operator) == "table")
            local proc = eval(operator, env)
            local ret = apply(proc, operands, env)
            return ret
        end
    end
end

function eval(expr, env)
    assert(env)

    if is_num(expr) then
        return expr_val(expr)
    elseif is_str(expr) then
        return expr_val(expr)
    elseif is_sym(expr) then
        return apply_env(env, expr_val(expr))
    elseif is_bool(expr) then
        return expr_val(expr)
    elseif is_proc(expr) then
        return expr
    elseif is_compound_expr(expr) then
        local operator = expr[1]
        local operands = table.ifilter(expr, function(i, _) return i ~= 1 end)
        return apply(operator, operands, env)
    else
        table.deep_print(expr)
        assert(false, "unknow expression")
    end
end

function interp(filename, verbose)
    global_env = init_env()
    for i, e in ipairs(read(filename) or {}) do
        local ret = eval(e, global_env)
        if verbose then
            print(ret)
        end
    end
end
