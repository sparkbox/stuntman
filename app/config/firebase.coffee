env = require 'config/environment'

# App.Store = FP.Store.extend
#   firebaseRoot: env.get('firebaseUrl')
# App.Store = DS.Store.extend()

App.ApplicationAdapter = DS.FirebaseAdapter.extend
  firebase: new Firebase(env.get('firebaseUrl'))

App.ApplicationSerializer = DS.FirebaseSerializer.extend()