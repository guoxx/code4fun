local barrier = "x"
local cat = "$"
local bone = "@"
local strmap = {
    "           "           ,
    "   x       "           ,
    "   x     x "           ,
    " $ x  x    "           ,
    " x x    x@ "           ,
    "         x "           ,
}

local function map_size()
    return #strmap, string.len(strmap[1])
end

local function map_at(i, j)
    local row, col = map_size()
    assert(i <= row, j <= col)
    return string.sub(strmap[i], j, j)
end

local function map_iter(func)
    local row, col = map_size()
    for r = 1, row do
        for c = 1, col do
            if func(r, c) then
                return
            end
        end
    end
end

local function cat_pos()
    local r, c
    map_iter(function(i, j)
        local v = map_at(i, j)
        if v == cat then
            r, c = i, j
            return true
        else
            return false
        end
    end)
    return r, c
end

local function bone_pos()
    local r, c
    map_iter(function(i, j)
        local v = map_at(i, j)
        if v == bone then
            r, c = i, j
            return true
        else
            return false
        end
    end)
    return r, c
end

local function adjacent_pos(i, j)
    local tbl = {}
    map_iter(function(r, c)
        if math.abs(i - r) + math.abs(j - c) == 1 then
            table.insert(tbl, {x = r, y = c})
        end
        return false
    end)
    return tbl
end

local p_cat = {}
local p_bone = {}
p_cat.x, p_cat.y = cat_pos()
p_bone.x, p_bone.y = bone_pos()

local function calc_dis(p1, p2)
    return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end

local openlist = {}
local closedlist = {}

local function _new_node(x, y, g, h)
    local t = {x = x, y = y, g = g, h = h}
    if g ~= nil and h ~= nil then
        t.f = g + h
    end
    return t
end

local function lowest_score_in_openlist()
    local idx = nil
    local n = nil
    for i, v in ipairs(openlist) do
        if n == nil then
            idx, n = i, v
        else
            if v.f < n.f then
                idx, n = i, v
            end
        end
    end
    return idx, assert(n)
end

local function node_at_list(ls, x, y)
    for i, v in ipairs(ls) do
        if v.x == x and v.y == y then
            return v
        end
    end
    return nil
end

table.insert(
    openlist,
    _new_node(p_cat.x, p_cat.y, calc_dis(p_cat, p_cat), calc_dis(p_cat, p_bone))
)
while #openlist > 0 do

    local idx, cur_node = lowest_score_in_openlist()
    table.insert(closedlist, cur_node)
    table.remove(openlist, idx)

    if node_at_list(closedlist, p_bone.x, p_bone.y) ~= nil then
        break
    end

    for _, pos in ipairs(adjacent_pos(cur_node.x, cur_node.y)) do
        if map_at(pos.x, pos.y) ~= barrier then
            if node_at_list(closedlist, pos.x, pos.y) ~= nil then

            else
                local n = node_at_list(openlist, pos.x, pos.y)
                if n == nil then
                    n = _new_node(pos.x, pos.y, calc_dis(pos, cur_node) + cur_node.g, calc_dis(pos, p_bone))
                    n.parent = cur_node
                    table.insert(openlist, n)
                else
                    local new_g = calc_dis(pos, cur_node) + cur_node.g
                    if new_g < n.g then
                        n.g = new_g
                        n.f = new_g + n.h
                        n.parent = cur_node
                    end
                end

            end
        end
    end
end

local t = {}
for i = #closedlist, 1, -1 do
    table.insert(t, closedlist[i])
end

local p = t[1].parent
while p ~= nil do
    print(p.x, p.y)
    p = p.parent
end
