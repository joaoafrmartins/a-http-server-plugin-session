module.exports =
  'retries': 3
  'redis':
    'port': 0
    'host': 'localhost'
  'options':
    'name': 'jsessionid'
    'secret': 'session secret'
    'resave': true
    'saveUninitialized': true,
    'cookie':
      'secure': false
      'maxAge': 3600000
