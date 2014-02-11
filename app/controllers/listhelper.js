var d3 = require('d3'),
	paths = exports.paths = {},
	icons = exports.icons = {};

paths.arrowup = 'M23.963,20.834L17.5,9.64c-0.825-1.429-2.175-1.429-3,0L8.037,20.834c-0.825,1.429-0.15,2.598,1.5,2.598h12.926C24.113,23.432,24.788,22.263,23.963,20.834z';
paths.arrowdown = 'M8.037,11.166L14.5,22.359c0.825,1.43,2.175,1.43,3,0l6.463-11.194c0.826-1.429,0.15-2.598-1.5-2.598H9.537C7.886,8.568,7.211,9.737,8.037,11.166z';
paths.check = 'M2.379,14.729 5.208,11.899 12.958,19.648 25.877,6.733 28.707,9.561 12.958,25.308z';
paths.cross = 'M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248z';
paths.mail = 'M28.516,7.167H3.482l12.517,7.108L28.516,7.167zM16.74,17.303C16.51,17.434,16.255,17.5,16,17.5s-0.51-0.066-0.741-0.197L2.5,10.06v14.773h27V10.06L16.74,17.303z';

var iconDefsDiv = exports.defs = d3.select('body').append('div'),
	iconsSvg = iconDefsDiv.append('svg').attr('width', 0).attr('height', 0),
	iconDefs = iconsSvg.append('defs');

var iconSortGroup = iconDefs.append('svg:g').attr({id:'svg-sort',width:20, height:10, class:'icon-sort'});

iconSortGroup.append('svg:path').attr('id', 'path-arrowup').attr('class', 'icon-arrowup').attr('d', paths.arrowup).attr('transform', 'matrix(0.4,0,0,0.35,0,0)');
iconSortGroup.append('svg:path').attr('id', 'path-arrowdown').attr('class', 'icon-arrowdown').attr('d', paths.arrowdown).attr('transform', 'matrix(0.4,0,0,0.35,5.5,0)');

var iconStateGroup = iconDefs.append('svg:g').attr({id:'svg-state',width:30, height:30, class:'icon-state'});
iconStateGroup.append('svg:path').attr('id', 'path-check').attr('class', 'icon-check').attr('d', paths.check);
iconStateGroup.append('svg:path').attr('id', 'path-cross').attr('class', 'icon-cross').attr('d', paths.cross);
iconStateGroup.append('svg:path').attr('id', 'path-mail').attr('class', 'icon-mail').attr('d', paths.mail);

icons.sort = d3.select('body').append('div');

var iconsSortSvg = icons.sort.append('svg').attr({width:20, height:10, class:'icon-sort'});
// Need this xlink:xlink stuff due to bug in D3 stripping namespaces.
iconsSortSvg.append('svg:use').attr('xlink:xlink:href', '#svg-sort');

icons.state = d3.select('body').append('div');

var iconsStateSvg = icons.state.append('svg').attr({width:30, height:30, class:'icon-state'});
iconsStateSvg.append('svg:use').attr('xlink:xlink:href', '#svg-state');