db = require "../classes/db"

pool = db.sharedInstance()

handle = (req, res) ->
	res.header "Content-Type", "application/json"
	output = {}

	schoolId = 1

	pool.query db.queries.school_data, schoolId, (row) ->
		output.timetableFormat = row[0].timetable_format.split("|")

		res.send JSON.stringify output
exports.handle = handle
