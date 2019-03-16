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
	"place",
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


	-- Natural
	local natural = way:Find("natural")
	if natural ~= nil and natural ~= "" then
		local class = natural

		if G_COUNTS["natural"] == nil			then G_COUNTS["natural"] = {}			end
		if G_COUNTS["natural"][class] == nil	then G_COUNTS["natural"][class] = 0		end

		-- if is_in( class, { "wood", "forest", "scrub", "heath", "grassland", "fell", "bare_rock", "scree", "shingle", "sand", "mud" } )
		if is_in( class, { "water", "wetland", "bay" } )then
			layer = "water"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		elseif is_in( class, { "mud" } )then
			layer = "mud"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["natural"][class] = G_COUNTS["natural"][class] + 1
		end
	end

	-- waterway
	local waterway = way:Find("waterway")
	if waterway ~= nil and waterway ~= "" then
		local class = waterway

		if G_COUNTS["waterway"] == nil			then G_COUNTS["waterway"] = {}			end
		if G_COUNTS["waterway"][class] == nil	then G_COUNTS["waterway"][class] = 0		end

		-- if is_in( class, { "yes", "water", "river", "riverbank", "stream", "reservoir", "moat", "pond", "canal" } )
		if is_in( class, { "yes", "water", "riverbank", "reservoir", "moat", "pond", "canal" } ) then
			layer = "water"
			way:Layer(layer, true)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["waterway"][class] = G_COUNTS["waterway"][class] + 1
		elseif is_in( class, { "river", "stream", "canal" } )	then
			layer = "river"
			way:Layer(layer, false)
			way:Attribute("class", class)
			if name ~= nil and name ~= ""	then		way:Attribute("name",name)	end
			G_COUNTS["waterway"][class] = G_COUNTS["waterway"][class] + 1
		end
	end

end