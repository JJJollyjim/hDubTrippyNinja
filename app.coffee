express = require "express"
http = require "http"
path = require "path"
cluster = require "cluster"

if cluster.isMaster
	cpus = require("os").cpus()
	cluster.fork() for cpu in cpus

	console.log "Forked #{cpus.length} processes"

else
	routes =
	  login: require "./routes/login"
	  sync: require "./routes/sync"

	app = express()

	# Set port to $PORT or (if that's not set) 3000
	app.set "port", process.env.PORT or 3000

	# Required, even though we're not using it
	app.set "view engine", "jade"

	# Enable server logs
	app.use express.logger("dev")

	# Parses POST body
	app.use express.bodyParser()

	# Not really sure what this does...
	app.use app.router

	app.use (req, res, next) ->
		console.log(req.body)
		next()

	# Setup routes
	app.get "/login", routes.login.handle
	app.get "/sync", routes.sync.handle

	# Error handler
	if app.get("env") is "development" then app.use express.errorHandler()

	# Start server
	http.createServer(app).listen app.get("port"), ->
	  console.log "Express server listening on port #{app.get("port")}. Worker id #{cluster.worker.id}"
