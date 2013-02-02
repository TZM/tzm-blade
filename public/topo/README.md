#D3.js JSON and TopoJSON

use ogr2ogr to convert shape files to .json

    ☺ ogr2ogr -f "GeoJSON" /tmp/world.json world_borders.shp world_borders

TODO use the TopoJSON to reduce the size of these, see [https://github.com/mbostock/topojson/](https://github.com/mbostock/topojson/)

Command to convert to a topojson format, preserving the name

    ☺  topojson -o topo/AFG_adm1.json -p name json/AFG_adm1.json
