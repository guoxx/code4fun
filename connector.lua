function cell_protocol()
	local cell = {}

	function cell:processNewValue()
	end
	function cell:processForgetValue()
	end

	return cell
end

function connector()
	local conn = {}

	local val
	local informant = false
	local constraints = {}

	function conn:hasValue()
		return val ~= nil
	end

	function conn:getValue()
		return val
	end

	function conn:setValue(v, setter)
		val = v
		informant = setter

		for k,c in pairs(constraints) do
			if c ~= informant then
				c:processNewValue()
			end
		end
	end

	function conn:forgetValue(v, retractor)
		if retractor == informant then
			val = nil
			informant = false
			for k, c in pairs(constraints) do
				if c ~= retractor then
					c:processForgetValue()
				end
			end
		end
	end

	function conn:connect(constraint)
		table.insert(constraints, constraint)
	end

	return conn
end

function cell_adder(a1, a2, sum)
	local cell = cell_protocol()

	function cell:processNewValue()
		if a1:hasValue() and a2:hasValue() then
			sum:setValue(a1:getValue() + a2:getValue(), cell)
		elseif a1:hasValue() and sum:hasValue() then
			a2:setValue(sum:getValue() - a1:getValue(), cell)
		elseif a2:hasValue() and sum:hasValue() then
			a1:setValue(sum:getValue() - a2:getValue(), cell)
		end
	end

	function cell:processForgetValue()
		sum:forgetValue(cell)
		a1:forgetValue(cell)
		a2:forgetValue(cell)
		self:processNewValue()
	end

	a1:connect(cell)
	a2:connect(cell)
	sum:connect(cell)
	return cell
end

function cell_probe(name, conn)
	local cell = cell_protocol()

	function cell:processNewValue()
		print("Probe: ", name, " = ", conn:getValue())
	end

	function cell:processForgetValue()
		print("Probe: ", name, " =  ?")
	end

	conn:connect(cell)
	return cell
end

function cell_constant(x, conn)
	local cell = cell_protocol()

	function cell:processNewValue()
		assert(false)
	end

	function cell:processForgetValue()
		assert(false)
	end

	conn:setValue(x, cell)
	conn:connect(cell)
	return cell
end

local a1 = connector()
local a2 = connector()
local sum = connector()

cell_probe("AAA", a1)
cell_probe("BBB", a2)
cell_probe("CCC", sum)

cell_adder(a1, a2, sum)
a1:setValue(1, "me")
cell_constant(2, a2)
a1:forgetValue("me")
a1:setValue(4, "me")