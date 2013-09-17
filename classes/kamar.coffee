http = require "http"
querystring = require "querystring"
xml2js = require "xml2js"

class client
	constructor: (school_row) ->
		@host = school_row.kamar_url.split("/")[0]
		@user = school_row.kamar_user
		@pass = school_row.kamar_pass

		@period_layout = school_row.class_periods
	
	api_request: (query, callback) ->
		post_data = querystring.stringify query

		options =
			host: @host
			port: 80
			path: "/api/api.php"
			method: "POST"
			headers:
				"Content-Type": "application/x-www-form-urlencoded"
				"Content-Length": post_data.length

		req = http.request options, (res) ->
			res.setEncoding "utf8"
			buffer = ""

			res.on "data", (chunk) ->
				buffer += chunk
			res.on "end", ->
				xml2js.parseString buffer, (err, result) ->
					if err? then throw new Error err
					callback result

		req.write post_data
		req.end()

exports.client = client
