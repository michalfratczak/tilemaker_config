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

	-- road_label layer
	local highway = way:Find("highway")
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
end