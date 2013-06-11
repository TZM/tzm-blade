#D3.js JSON and TopoJSON

To download the .shp files use [http://www.gadm.org/download](http://www.gadm.org/download)

use ogr2ogr to convert shape files to .json

    ☺ ogr2ogr -f "GeoJSON" /tmp/world.json ~/Downloads/world_borders.shp world_borders

Use the TopoJSON to reduce the size of these, see [https://github.com/mbostock/topojson/](https://github.com/mbostock/topojson/)

Command to convert to a topojson format, preserving Name and Type and are also simplified with the -s 10e-9 precision threshold for Visvalingam simplification, in steradians setting. See [https://github.com/mbostock/topojson/wiki/Command-Line-Reference](https://github.com/mbostock/topojson/wiki/Command-Line-Reference)

    ☺  topojson -o data/topo/USA_adm1.json -p NAME_1=country -p TYPE_1 /tmp/USA_adm1.json

