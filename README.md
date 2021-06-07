Example usage and config of tilemaker
==========================================

This shows how to configure and use tilemaker and how to get input data.
https://github.com/systemed/tilemaker

Configuration files are tailored for use with MapBox.
Here is demo showing how maps rendering look like with mapbox: https://www.youtube.com/watch?v=ZuoNf171e_A&t=2s

This repo is very much WIP-state.

Getting tilemaker
------------------------
YOu can either build from source or download precompiled executable from GitHubs Continous Integration:
https://github.com/systemed/tilemaker/actions/workflows/ci.yml

Go to last successful build, and at the bottom of the page you should see links to EXEcs (Artifacts).

Getting OSM Data
------------------------

First, you need to download OSM data _EXTRACT_ in pbf format.
Get it from here:

http://download.geofabrik.de/europe/poland.html
http://download.geofabrik.de/europe/poland-latest.osm.pbf

Getting boundaries shape files
-------------------------------

https://wambachers-osm.website/boundaries/

Converting PBF to Tiles
------------------------

Tilemaker is executed from update.sh script.
Take a look inside - the process is divided into layers, because tilemaker can be mem hungry. Besides, for me, it's easier to work that way ...

Example usage:

```./update.sh ./poland-latest.osm.pbf ./poland_tiles```

You should get a poland_tiles directory with subdirs per each layer.


Getting Fonts
------------------
Download from https://github.com/openmaptiles/fonts/releases


Serving tiles with apache
------------------------------

Copy/symlink tiles and fonts

        sudo mkdir /var/www/html/osm
        sudo chmod a+rwx /var/www/html/osm
        cp ./static/index.html /var/www/html/osm/
        sudo ln -s ./poland_tiles /var/www/html/osm/poland_tiles
        sudo ln -s ./fonts /var/www/html/osm/fonts


Serving tiles with python bottle
------------------------------------
to do - but look into server.py


todo:
------
- fix server to actually serve some html (and not only tiles)
- fix html with comments and paths to OSM directiories

