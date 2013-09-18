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
				xml2js.parseString buffer, {explicitRoot: false, explicitArray: false}, (err, result) ->
					if err? then throw new Error err
					if result.ErrorCode isnt "0" then throw new Error "KAMAR error"
					callback result

		req.write post_data
		req.end()

	authenticate: (callback) ->
		@api_request {
			Command: "Logon"
			Key: "vtku"
			Username: @user
			Password: @pass
		}, (result) =>
			if result.Success isnt "YES" then err = new Error("Login failed!")
			@key = result.Key

			callback err
exports.client = client
