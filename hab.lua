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

	local place = node:Find("place")
	local capital = node:Find("capital")
	local admin_level = node:Find("admin_level")
	local name = node:Find("name")
	local aeroway = node:Find("aeroway")
	-- local shop = node:Find("shop")
	-- local amenity = node:Find("amenity")

	-- place
	if place ~= nil and place ~= "" then
		node:Layer("place_label", false)
		node:Attribute("name",name)
		-- the main field for styling labels for different kinds of places is type.
		-- possible values: 'city','town','village','hamlet','suburb','neighbourhood'
		node:Attribute("type",place)
		--The capital field allows distinct styling of labels or icons for the capitals of countries, regions, or states & provinces.
		-- 2=National capital, 3=Regional capital (uncommon), 4=State/provincial capital
		if capital ~="" then
			if admin_level == 2 then
				node:AttributeNumeric("capital",2)
			end
			if admin_level == 4 then
				node:AttributeNumeric("capital",4)
			end
		end
		-- The value number from 0 through 9, where 0 is the large end of the scale (eg New York City).
		-- All places other than large cities will have a scalerank of null.
		if place == "village" then
			node:AttributeNumeric("scalerank",3)
		end
		if place == "town" then
			node:AttributeNumeric("scalerank",5)
		end
		if place == "suburb" then
			node:AttributeNumeric("scalerank",7)
		end
		if place == "city" then
			node:AttributeNumeric("scalerank",9)
		end
		-- Therefore to reduce the label density to 4 labels per tile, you can add the filter [localrank=1].
		node:AttributeNumeric("localrank",1)
		-- The ldir field can be used as a hint for label offset directions at lower zoom levels.
		node:Attribute("ldir","N")
	end
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

	-- road_label layer
	if highway ~= nil and highway ~= "" and name ~= "" then
		way:Layer("road_label", false)
		way:Attribute("name",name)
		if way:Find("ref") ~="" then
			way:Attribute("ref",way:Find("ref"))
			way:AttributeNumeric("reflen", string.len(way:Find("ref")))
		end
		way:AttributeNumeric("osm_id",tonumber(way:Id()))
		way:Attribute("shield","default")
		way:AttributeNumeric("len", 100)
		way:AttributeNumeric("localrank", 3)
		--"class","len","localrank","name","name_de","name_en","name_es","name_fr","name_ru","name_zh","osm_id","ref","reflen","shield"
		--way:AttributeBoolean("oneway": "false")
		if highway=="residential" then way:Attribute("class","street") end
		if highway=="primary" or highway=="secondary" or highway=="tertiary" then
				way:Attribute("class","main")
		end
		if highway=="primary_link" or highway=="secondary_link" then
			way:Attribute("class","street")
		end
	end


	-- -- route
	-- local route = way:Find("route")
	-- if route ~= nil and route ~= "" then
	-- 	local class = route

	-- 	if G_COUNTS["route"] == nil			then G_COUNTS["route"] = {}				end
	-- 	if G_COUNTS["route"][class] == nil	then G_COUNTS["route"][class] = 0		end

	-- 	-- if is_in( class, { "wood", "scrub", "heath", "grassland", "fell", "bare_rock", "scree", "shingle", "sand", "mud" } )
	-- 	layer = "route"
	-- 	way:Layer(layer, false)
	-- 	way:Attribute("class", class)
	-- 	G_COUNTS["route"][class] = G_COUNTS["route"][class] + 1
	-- end

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
		G_COUNTS["building"][class] = G_COUNTS["building"][class] + 1
	end

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
		elseif is_in( class, { "water", "wetland", "bay" } )then
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
		else
			layer = "natural_other"
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


	-- boundary
	-- local boundary = way:Find("boundary")
	-- if boundary ~= nil and boundary == "administrative" then
	-- 	local class = boundary
	-- 	local admin_level = way:Find("admin_level")

	-- 	if G_COUNTS["admin_level"] == nil			then G_COUNTS["admin_level"] = {}			end


	-- 	if admin_level ~= nil and admin_level ~= ""	then

	-- 		if G_COUNTS["boundary"] == nil			then G_COUNTS["boundary"] = {}			end
	-- 		if G_COUNTS["boundary"][class] == nil	then G_COUNTS["boundary"][class] = 0		end

	-- 		if G_COUNTS["admin_level"][admin_level] == nil then G_COUNTS["admin_level"][admin_level] = 0 end
	-- 		G_COUNTS["admin_level"][admin_level] = G_COUNTS["admin_level"][admin_level] + 1


	-- 		layer = "admin"
	-- 		way:Layer(layer, false)
	-- 		way:Attribute("class", class)
	-- 		if name ~= nil and name ~= ""	then
	-- 			way:Attribute("name",name)
	-- 		end

	-- 		way:AttributeNumeric("admin_level", admin_level)

	-- 		G_COUNTS["boundary"][class] = G_COUNTS["boundary"][class] + 1
	-- 	end -- admin level
	-- end

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