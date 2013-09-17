handle = (req, res) ->
	res.header "Content-Type", "application/json"
	res.send "Rendered Sync"

exports.handle = handle
