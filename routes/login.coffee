handle = (req, res) ->
	res.header "Content-Type", "application/json"
	res.send "Rendered Login"

exports.handle = handle
