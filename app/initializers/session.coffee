###
 Working authentication with
 Firebase 2.0.x + Ember.js 1.8.1 + Ember Data Canary + EmberFire 1.3.0 + Ember CLI
 In templates: <button {{action 'login' 'google'}}>Log in with Google</button>
###

# global md5
`import Ember from 'ember';`

# Since I've defined my url in environment.js I can do this
`import ENV from '../config/environment';`

ref = new window.Firebase ENV.firebaseURL

Session =
  name: 'session',

  # Run the initializer after the store is ready
  after: 'store',

  initialize: (container, app) ->
    # session object is nested here as we need access to the container to get the store
    session = Ember.Object.extend

      # initial state
      authed: false,

      # get access to the ember data store
      store: container.lookup('store:main'),

      init: ->
        # on init try to login
        ref.onAuth((authData) ->

          # Not authenticated
          if (!authData)
            @set('authed', false)
            @set('authData', null)
            @set('user', null)
            return false

          # Authenticated
          @set('authed', true)
          @set('authData', authData)
          @afterAuthentication(authData.uid)
        ).bind(@)

      # Call this from your Ember templates
      login: (provider) ->
        @_loginWithPopup(provider)

      # Call this from your Ember templates
      logout: ->
        ref.unauth()

      # Default login method
      _loginWithPopup: (provider) ->
        Ember.debug('logging in with popup');
        ref.authWithOAuthPopup provider, (error, authData) =>
          if error
            if error.code is "TRANSPORT_UNAVAILABLE"
              # fall-back to browser redirects, and pick up the session
              # automatically when we come back to the origin page
              @._loginWithRedirect(provider)
          # else
          #   if authData
          # we're good!
          # this will automatically call the on ref.onAuth method inside init()

      # Alternative login with redirect (needed for Chrome on iOS)
      _loginWithRedirect: (provider) ->
        ref.authWithOAuthRedirect provider, (error, authData) ->
          if error
            console.log "error"
          # else if authData
          # we're good!
          # this will automatically call the on ref.onAuth method inside init()

      # Runs after authentication
      # It either sets a new or already exisiting user
      afterAuthentication: (userId) ->
        # See if the user exists using native Firebase because of EmberFire problem with "id already in use"
        ref.child('users').child(userId).once 'value', (snapshot) ->
          exists = (snapshot.val() isnt null)
          userExistsCallback(userId, exists)

        # Do the right thing depending on whether the user exists
        userExistsCallback = (userId, exists) =>
          if exists
            @existingUser(userId)
          else
            @createUser(userId)

      # Existing user
      existingUser: (userId) ->
        @store.find('user', userId).then((user) ->
          @set('user', user)
        ).bind(@)

      # Create a new user
      createUser: (userId) ->
        @get('store').createRecord('user',
          id: userId
          provider: @get('authData.provider')
          name: @get('authData.facebook.displayName') or @get('authData.google.displayName')
          email: @get('authData.facebook.email') or @get('authData.google.email')
          created: new Date().getTime()
        ).save().then (user) ->
          # Proceed with the newly create user
          @set('user', user)

      # This is the last step in a successful authentication
      # Set the user (either new or existing)
      afterUser: (user) ->
        @set('user', user)

    # Register and inject the 'session' initializer into all controllers and routes
    app.register('session:main', session)
    app.inject('route', 'session', 'session:main')
    app.inject('controller', 'session', 'session:main')


`export default Session;`
