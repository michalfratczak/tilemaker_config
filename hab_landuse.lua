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

	-- landuse
	local landuse = way:Find("landuse")
	if landuse ~= nil and landuse ~= "" then
		local class = landuse

		if G_COUNTS["landuse"] == nil			then G_COUNTS["landuse"] = {}			end
		if G_COUNTS["landuse"][class] == nil	then G_COUNTS["landuse"][class] = 0		end

		-- if is_in( class, { "wood", "scrub", "heath", "grassland", "fell", "bare_rock", "scree", "shingle", "sand", "mud" } )
		layer = "landuse"
		way:Layer(layer, true)
		way:Attribute("class", class)
		if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
		G_COUNTS["landuse"][class] = G_COUNTS["landuse"][class] + 1
	end

	-- Natural
	local natural = way:Find("natural")
	if natural ~= nil and natural ~= "" then
		local class = natural

		if G_COUNTS["natural"] == nil			then G_COUNTS["natural"] = {}			end
		if G_COUNTS["natural"][class] == nil	then G_COUNTS["natural"][class] = 0		end

		-- if is_in( class, { "wood", "forest", "scrub", "heath", "grassland", "fell", "bare_rock", "scree", "shingle", "sand", "mud" } )
		if is_in( class, { "wood", "forest", "scrub" } ) then -- just higher trees
			layer = "wood"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		elseif is_in( class, { "heath", "grassland", "fell" } ) then
			layer = "bush"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		elseif is_in( class, { "bare_rock", "scree", "shingle", "sand", "meadow" } ) then
			layer = "soil"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		else
			layer = "natural_other"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		end
	end
end