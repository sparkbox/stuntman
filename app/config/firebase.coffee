env = require 'config/environment'

App.Store = DS.Store.extend()

App.ApplicationAdapter = DS.FirebaseAdapter.extend
  firebase: new Firebase(env.get('firebaseUrl'))

# App.ApplicationSerializer = DS.FirebaseSerializer.extend()
