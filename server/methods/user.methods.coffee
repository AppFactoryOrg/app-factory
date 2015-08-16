Meteor.methods
	'User.register': (parameters) ->
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])

		role = parameters['role']

		user =
			'email': parameters['email']
			'profile':
				'name': parameters['name']
				'application_roles': if role? then [role] else []

		user['_id'] = Accounts.createUser(user)

		Accounts.sendEnrollmentEmail(user['_id'])

		Meteor.call('Billing.createCustomer', user)

		return

	'User.invite': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessApplication(Meteor.userId(), parameters['application_id'], true)
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])
		throw new Meteor.Error('validation', 'Application not specified') if _.isEmpty(parameters['application_id'])
		throw new Meteor.Error('limits', 'Application user limit reached') unless Limits.canInviteUser(parameters['application_id'])

		application = Application.db.findOne(parameters['application_id'])
		throw new Meteor.Error('validation', 'Application could not be found') unless application?

		user = User.db.findOne({'emails.address': parameters['email']})

		role =
			'application_id': parameters['application_id']
			'role': User.ROLE['User'].value
			'can_edit': false

		if user?
			if _.some(user['profile']['application_roles'], {'application_id': parameters['application_id']})
				throw new Meteor.Error('logic', 'User already has access to the application')

			User.db.update(user['_id'],
				$addToSet:
					'profile.application_roles': role
			)
		else
			parameters['role'] = role
			Meteor.call('User.register', parameters)

		Application.updateUserCount(parameters['application_id'])

		return

	'User.revoke': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessApplication(Meteor.userId(), parameters['application_id'], true)
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'User not specified') if _.isEmpty(parameters['user_id'])
		throw new Meteor.Error('validation', 'Application not specified') if _.isEmpty(parameters['application_id'])
		throw new Meteor.Error('logic', 'Cannot revoke your own user') if parameters['user_id'] is Meteor.userId()

		application = Application.db.findOne(parameters['application_id'])
		throw new Meteor.Error('validation', 'Application could not be found') unless application?

		user = User.db.findOne(parameters['user_id'])
		throw new Meteor.Error('validation', 'User could not be found') unless user?
		throw new Meteor.Error('logic', 'Cannot revoke the application\'s owner') if User.isApplicationOwner({user, application})

		User.db.update(user['_id'],
			$pull:
				'profile.application_roles': {'application_id': application['_id']}
		)

		Application.updateUserCount(parameters['application_id'])

		return
