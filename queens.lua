function join(ls, n)
    local tbl = {}
    for i, v in ipairs(ls) do
        table.insert(tbl, v)
    end
    table.insert(tbl, n)
    return tbl
end

function filter(ls, func)
    local tbl = {}
    for _, v in pairs(ls) do
        if func(v) then
            table.insert(tbl, v)
        end
    end
    return tbl
end

function is_safe(ls, pos, k)
    for i, v in ipairs(ls) do
        if math.abs((pos - v) / (#ls + 1 - i)) == 1 then
            return false
        end
    end
    return true
end

function queens(boardsize)
    local results = {}
    local function queen_cols(positions, rest_positions, k)
        if k == 0 then
            return positions
        else
            for _, v in ipairs(rest_positions) do
                local pos = v
                if is_safe(positions, pos) then
                    local rs = queen_cols(join(positions, pos), filter(rest_positions, function(n) return n ~= pos end), k - 1)
                    table.insert(results, rs)
                end
            end
        end
    end

    local pos = {}
    local rest_pos = {}
    for i = 1, boardsize do
        table.insert(rest_pos, i)
    end

    queen_cols(pos, rest_pos, boardsize)
    return results
end

results = queens(13)
print("number of results " .. #results)
print("")
for i,v in ipairs(results) do
	for i, n in ipairs(v) do
        io.write(tostring(n) .. " ")
    end
    print("")
end
