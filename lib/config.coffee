module.exports =
  'retries': 3
  'redis':
    'host': 'localhost'
    'port': 6379
  'options':
    'name': 'jsessionid'
    'secret': 'session secret'
    'resave': true
    'saveUninitialized': true,
    'cookie':
      'secure': false
      'maxAge': 3600000
