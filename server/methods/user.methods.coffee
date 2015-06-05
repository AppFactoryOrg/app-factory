Meteor.methods
	'User.register': (parameters) ->
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])
		throw new Meteor.Error('validation', 'Password is required') if _.isEmpty(parameters['password'])
		throw new Meteor.Error('validation', 'Passwords must match') unless parameters['password'] is parameters['confirmPassword']

		user = 
			'email': parameters['email']
			'password': parameters['password']
			'profile':
				'name': parameters['name']
				'application_roles': []

		Accounts.createUser(user)

		return

	'User.invite': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])
		throw new Meteor.Error('validation', 'Application not specified') if _.isEmpty(parameters['application_id'])

		application = Application.db.findOne(parameters['application_id'])
		throw new Meteor.Error('data', 'Application could not be found') unless application?

		user = Meteor.users.findOne({'emails.address': parameters['email']})

		role = 
			'application_id': parameters['application_id']
			'role': 'user'

		if user?
			if _.some(user['profile']['application_roles'], {'application_id': parameters['application_id']})
				throw new Meteor.Error('conflict', 'User already has access to the application')
				
			Meteor.users.update(user['_id'],
				$addToSet: 
					'profile.application_roles': role
			)
		else
			# TODO: send invite code

		return

			

