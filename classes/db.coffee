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
				conn.release()
				callback(rows)

queries =
	test: "SELECT ? + ? AS result"

exports.pool = pool
exports.queries = queries