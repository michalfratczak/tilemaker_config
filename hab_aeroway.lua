-- https://taginfo.openstreetmap.org/keys

node_keys = {
	-- "Aerialway",
	-- "Aeroway",
	-- "Amenity",
	-- "Barrier",
	-- "Boundary",
	-- "building",
	-- "Craft",
	-- "Emergency",
	-- "Geological",
	-- "Highway",
	-- "Historic",
	-- "Common Landuse Key Values",
	-- "Other Landuse Key Values",
	-- "Leisure",
	-- "Man_made",
	-- "Military",
	-- "natural",
	-- "Office",
	-- "place",
	-- "Power",
	-- "Public Transport",
	-- "Railway",
	-- "Route",
	-- "Shop",
	-- "Sport",
	-- "Telecom",
	-- "Tourism",
	-- "Waterway"
}

G_DEFAULT = 0
G_COUNTS = {}


function init_function()
end


local function is_in (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end


function exit_function()
	for _k,_v in pairs(G_COUNTS)
	do
		print("\n")
		print(_k)
		for k,v in pairs(_v)
		do
			print("\t", k, v)
		end
	end
end


function node_function(node)
end


function way_function(way)
	local layer = nil

	local name = way:Find("name");

	-- aeroway
	local aeroway = way:Find("aeroway")
	if aeroway ~= nil and aeroway ~= "" then
		local class = aeroway

		if G_COUNTS["aeroway"] == nil			then G_COUNTS["aeroway"] = {}			end
		if G_COUNTS["aeroway"][class] == nil	then G_COUNTS["aeroway"][class] = 0		end

		if is_in( class, { "aerodrome", "apron"} )then
			layer = "aeroway"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["aeroway"][class] = G_COUNTS["aeroway"][class] + 1
		else
			layer = "aeroway_other"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["aeroway"][class] = G_COUNTS["aeroway"][class] + 1
		end
	end
end