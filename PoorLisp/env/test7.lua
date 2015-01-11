function func1(n)
    if n <= 0 then
        return 0
    else
        return n + func1(n - 1)
    end
end

function func2(n)
    local function _iter(v, n)
        if n <= 0 then
            return v
        else
            return _iter(v + n, n - 1)
        end
    end
    return _iter(0, n)
end

arg = ...
print(_G[arg](10000000))
