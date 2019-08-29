
node_keys = {
}

function init_function()
end

function exit_function()
end

function node_function(node)
end

function way_function(way)
	-- something has to be written
	-- boundary
	local boundary = way:Find("boundary")
	if boundary ~= nil and boundary == "administrative" then
		local class = boundary
		local admin_level = way:Find("admin_level")

		if admin_level ~= nil and admin_level ~= ""	then
			layer = "unused"
			way:Layer(layer, false)
		end -- admin level
	end
end
