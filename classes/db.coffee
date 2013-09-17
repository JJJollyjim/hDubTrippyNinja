mysql = require "mysql"

class pool
	constructor: (host, user, pass) ->
		@pool = mysql.createPool
			host: host
			user: user
			password: pass
			database: 'kamar'

	runquery: (query, args..., callback) ->
		@pool.getConnection (err, conn) ->
			throw new Error(err) if err?

			conn.query query, args, (err, rows) ->
				throw new Error(err) if err?

				conn.release()
				callback(rows)

sharedInstance = (host, user, pass) ->
	if !global.shared_db_pool? 
		global.shared_db_pool = new pool host, user, pass

	global.shared_db_pool

queries =
	test: "SELECT ? + ? AS result"

exports.pool = pool
exports.queries = queries
exports.sharedInstance = sharedInstance