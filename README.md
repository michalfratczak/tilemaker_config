Example usage and config of tilemaker.

First, you need to download OSM data in pbf format.
Get it from here:
    http://download.geofabrik.de/europe/poland.html
    http://download.geofabrik.de/europe/poland-latest.osm.pbf

Tilemaker is executed from update.sh script.
Take a look inside - the process is divided into layers, because tilemaker can be mem hungry, besides, for me, it's easier to work that way ...

Example usage:

```./update.sh ./poland-latest.osm.pbf ./poland_tiles```

You're now ready to serve your tiles:
    
    - with apache:
        sudo mkdir /var/www/html/osm
        sudo chmod a+rwx /var/www/html/osm
        cp ./static/index.html /var/www/html/osm/
        sudo ln -s ./poland_tiles /var/www/html/osm/poland_tiles

    or

    - with python bottle (server.py): ./server.py


todo:
- fix server to actually serve some html (and not only tiles)
- fix html with comments and paths to OSM directiories
- add font download location
