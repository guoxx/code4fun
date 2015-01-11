local function parse_str(txt, i, e)
    assert(string.idx(txt, i) == "\"")
    for j = i + 1, e do
        local c = string.idx(txt, j)
        if c == "\"" then
            return j + 1, string.sub(txt, i, j)
        end
    end
    return e + 1, nil
end

local function parse_stat(txt, i, e)
    for j = i + 1, e do
        local c = string.idx(txt, j)
        if c == " " or c == "(" or c == ")" or c == "\n" then
            local s = string.sub(txt, i, j - 1)
            local n = tonumber(s)
            local x = n or s
            return j, x
        end
    end
    return e + 1, nil
end

local function parse_expr(txt, i, e)
    assert(string.idx(txt, i) == "(")
    local expr = {}
    local j = i + 1
    while j <= e do
        local c = string.idx(txt, j)
        if c == ")" then
            return j + 1, expr
        elseif c == "(" then
            local n, exp = parse_expr(txt, j, e)
            j = n
            if exp ~= nil then
                table.insert(expr, exp)
            end
        elseif c == "\"" then
            local n, str = parse_str(txt, j, e)
            j = n
            if str ~= nil then
                table.insert(expr, str)
            end
        elseif c ~= " " and c ~= "\n" then
            local n, stat = parse_stat(txt, j, e)
            j = n
            if stat ~= nil then
                table.insert(expr, stat)
            end
        else
            j = j + 1
        end
    end
    return j, nil
end

function parse(txt)
    local exprs = {}
    local len = string.len(txt)
    local i = 1
    while i <= len do
        local c = string.idx(txt, i)
        if c == "(" then
            local c, expr = parse_expr(txt, i, len)
            i = c
            if expr ~= nil then
                table.insert(exprs, expr)
            end
        else
            i = i + 1
        end
    end
    return exprs
end
