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

	-- highway
	local highway = way:Find("highway")
	if highway ~= nil and highway ~= "" then
		local class = highway

		if G_COUNTS["highway"] == nil			then G_COUNTS["highway"] = {}			end
		if G_COUNTS["highway"][class] == nil	then G_COUNTS["highway"][class] = 0		end

		if is_in( class, { "motorway", "trunk", "primary", "motorway_link", "trunk_link", "primary_link" } ) then
			layer = "road_main"
			way:Layer(layer, false)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["highway"][class] = G_COUNTS["highway"][class] + 1
		end

		if is_in( class, { "secondary", "road", "secondary_link", "road_link" } ) then
			layer = "road_secondary"
			way:Layer(layer, false)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["highway"][class] = G_COUNTS["highway"][class] + 1
		end

		if is_in( class, { "tertiary", "tertiary_link" } )
		then
			layer = "road_tertiary"
			way:Layer(layer, false)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["highway"][class] = G_COUNTS["highway"][class] + 1
		end

		if is_in( class, {
							"track",
							"proposed",
							"service",
							-- "planned",
							"residential",
							"unclassified",
							"living_street",
							"path",
							-- "yes",
							-- "services",
							-- "raceway",
							-- "pedestrian",
							-- "trunk",
							-- "corridor",
							"crossing"
							-- "bus_stop",
							-- "bridleway",
							-- "platform",
							-- "elevator",
							-- "footway",
							-- "steps",
							-- "construction",
							-- "rest_area",
							-- "cycleway",
							-- "abandoned",
							-- "no",
					} )		then
			layer = "road_other"
			way:Layer(layer, false)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["highway"][class] = G_COUNTS["highway"][class] + 1
		end
	end

	-- railway
	local railway = way:Find("railway")
	if railway ~= nil and railway == "rail" then
		local class = railway

		if G_COUNTS["railway"] == nil			then G_COUNTS["railway"] = {}			end
		if G_COUNTS["railway"][class] == nil	then G_COUNTS["railway"][class] = 0		end

		layer = "railway"
		way:Layer(layer, false)
		way:Attribute("class", class)
		-- if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
		G_COUNTS["railway"][class] = G_COUNTS["railway"][class] + 1
	end

	if layer == nil then
		-- way:Layer("default", false)
		G_DEFAULT = G_DEFAULT + 1
	end

end