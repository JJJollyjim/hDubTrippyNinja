mysql = require "mysql"

class pool
	constructor: (host, user, pass) ->
		@pool = mysql.createPool
			host: host
			user: user
			password: pass
			database: 'kamar'

	query: (query, args..., callback) ->
		@pool.getConnection (err, conn) ->
			throw new Error(err) if err?

			conn.query query, args, (err, rows) ->
				throw new Error(err) if err?

				conn.release()
				callback(rows)

sharedInstance = (host, user, pass) ->
	host = host ? process.env.db_host
	user = user ? process.env.db_user
	pass = pass ? process.env.db_pass

	if !global.shared_db_pool?
		global.shared_db_pool = new pool host, user, pass

	global.shared_db_pool

queries =
	test: "SELECT ? + ? AS result"
	school_data: "SELECT * FROM school WHERE id = ?"

exports.pool = pool
exports.queries = queries
exports.sharedInstance = sharedInstance
