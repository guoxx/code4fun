-- table function
function table.accumulate(tbl, func, initial_val)
    local total = initial_val
    for k, v in pairs(tbl) do
        total = func(v, total)
    end
    return total
end

function table.filter(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        if func(k, v) then
            t[k] = v
        end
    end
    return t
end

function table.ifilter(tbl, func)
    local t = {}
    for i, v in ipairs(tbl) do
        if func(i, v) then
            table.insert(t, v)
        end
    end
    return t
end

function table.map(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = func(k, v)
    end
    return t
end

function table.contain(tbl, elem)
    for k, v in pairs(tbl) do
        if v == elem then
            return true
        end
    end
    return false
end

function table.print(tbl, verbose)
    for k, v in pairs(tbl) do
        if verbose then
            print(verbose, k, v)
        else
            print(k, v)
        end
    end
end

function table.deep_print(t)
	local function show(tbl, lvl)
		-- check type
		if type(tbl) ~= "table" then
			print(tbl, type(tbl))
			return
		end

		local indent = "  "

		local iter, ttype = pairs, "table"
		print(string.rep(indent, lvl) .. "{")

		for k, v in iter(tbl) do
			-- desc = string.format("%s:%s = %s:%s", type(k), tostring(k), type(v), tostring(v))
			local desc = string.format("%s = %s", tostring(k), tostring(v))
			print(" " .. string.rep(indent, lvl) .. desc)

			if type(v) == "table" then
				show(v, lvl + 1)
			end
		end

		print(string.rep(indent, lvl) .. "}")
	end

	print("----------------")
	show(t, 0)
	print("----------------")
end

-- string function
function string.idx(s, i)
    return string.char(string.byte(s, i))
end
