# Just renders index.blade
exports.index = (req, res) ->
	#map_html = d3.select('body').node().innerHTML)
  res.render "index",
    clicks: 0
