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

	-- building
	local building = way:Find("building")
	if building ~= nil and building ~= "" then
		local class = building

		if G_COUNTS["building"] == nil			then G_COUNTS["building"] = {}				end
		if G_COUNTS["building"][class] == nil	then G_COUNTS["building"][class] = 0		end

		layer = "building"
		way:Layer(layer, true)
		way:Attribute("class", class)
		if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end

		local height = way:Find("height");
		if height ~= nil and height ~= ""	then		way:Attribute("height",height)	end
		local min_height = way:Find("min_height");
		if min_height ~= nil and min_height ~= ""	then		way:Attribute("min_height",min_height)	end


		G_COUNTS["building"][class] = G_COUNTS["building"][class] + 1
	end
end