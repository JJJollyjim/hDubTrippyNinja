cluster = require "cluster"
express = require "express"
http    = require "http"
path    = require "path"

if cluster.isMaster
	cpus = require("os").cpus()
	console.log "Forking #{cpus.length} processes"

	cluster.fork() for cpu in cpus

	# If a worker dies, restart it
	cluster.on "exit", (worker) ->
		console.error "Worker #{worker.id} died!"
		console.log "Reforking..."
		cluster.fork()

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

	# Setup routes
	app.post "/login", routes.login.handle
	app.post "/sync", routes.sync.handle

	app.get "/", (req, res) ->
		res.send "Debug page"


	# Error handler
	if app.get "env" is "development" then app.use express.errorHandler()

	# Start server
	http.createServer(app).listen app.get("port"), ->
	  console.log "Express server listening on port #{app.get("port")}. Worker id #{cluster.worker.id}"
