session = require 'express-session'

RedisStore = require('connect-redis')(session)

configFn = require 'a-http-server-config-fn'

module.exports = (next) ->

  configFn @config, "#{__dirname}/config"

  options = @config.plugins.session.options

  options.store = new RedisStore(

    @config.plugins.session.redis

  )

  process.on "a-http-server:shutdown:dettach", () ->

    process.emit "a-http-server:shutdown:dettached", "session"

  options.secret = @config.middleware.cookies.secret

  options.cookie = @config.middleware.cookies.options

  middleware = session options

  @app.use (req, res, done) =>

    retries = @config.plugins.session.retries or 3

    lookup = (err) =>

      if err then return done err

      retries -= 1

      if req.session isnt undefined then return done()

      if retries < 0 then return done new Error 'session error'

      middleware req, res, lookup

    lookup()

  process.emit "a-http-server:shutdown:attach", "session"

  next null
