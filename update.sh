#!/bin/sh

# $1 is path to PBF file
# $2 is output dir

mkdir $2
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_aeroway.json 	--process ./hab_aeroway.lua 	--input $1 --output $2/aeroway
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_buildings.json 	--process ./hab_buildings.lua 	--input $1 --output $2/buildings
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_landuse.json 	--process ./hab_landuse.lua 	--input $1 --output $2/landuse
/usr/bin/time -v ./tilemaker --combine 0 --config ./hab_roads.json 		--process ./hab_roads.lua 		--input $1 --output $2/roads
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_water.json 		--process ./hab_water.lua 		--input $1 --output $2/water
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_labels.json 	--process ./hab_labels.lua 		--input $1 --output $2/labels
# /usr/bin/time -v ./tilemaker --combine 0 --config ./hab_admin.json 		--process ./hab_admin.lua 		--input $1 --output $2/admin
