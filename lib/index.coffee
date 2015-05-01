merge = require 'lodash.merge'

session = require 'express-session'

RedisStore = require('connect-redis')(session)

module.exports = (next) ->

  @config.session = merge require('./config'), @config?.session or {}

  @config.session.options.store = new RedisStore @config.session.redis

  process.on "a-http-server:shutdown:dettach", () ->

    process.emit "a-http-server:shutdown:dettached", "session"

  middleware = session @config.session.options

  @app.use (req, res, done) =>

    retries = @config.session.retries or 3

    lookup = (err) =>

      if err then return done err

      retries -= 1

      if req.session isnt undefined then return done()

      if retries < 0 then return done new Error 'session error'

      middleware req, res, lookup

    lookup()

  process.emit "a-http-server:shutdown:attach", "session"

  next null
