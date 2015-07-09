Meteor.methods
	'User.register': (parameters) -> Utils.logErrors ->
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])

		user =
			'email': parameters['email']
			'profile':
				'name': parameters['name']
				'application_roles': []

		user['_id'] = Accounts.createUser(user)

		Accounts.sendEnrollmentEmail(user['_id'])

		return

	'User.invite': (parameters) -> Utils.logErrors ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'Name is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Email is required') if _.isEmpty(parameters['email'])
		throw new Meteor.Error('validation', 'Application not specified') if _.isEmpty(parameters['application_id'])

		application = Application.db.findOne(parameters['application_id'])
		throw new Meteor.Error('data', 'Application could not be found') unless application?

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
			user =
				'email': parameters['email']
				'profile':
					'name': parameters['name']
					'application_roles': [role]

			user['_id'] = Accounts.createUser(user)

			Accounts.sendEnrollmentEmail(user['_id'])

		return

	'User.revoke': (parameters) -> Utils.logErrors ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Parameters are required') unless parameters?
		throw new Meteor.Error('validation', 'User not specified') if _.isEmpty(parameters['user_id'])
		throw new Meteor.Error('validation', 'Application not specified') if _.isEmpty(parameters['application_id'])
		throw new Meteor.Error('logic', 'Cannot revoke your own user') if parameters['user_id'] is Meteor.userId()

		application = Application.db.findOne(parameters['application_id'])
		throw new Meteor.Error('data', 'Application could not be found') unless application?

		user = User.db.findOne(parameters['user_id'])
		throw new Meteor.Error('data', 'User could not be found') unless user?
		throw new Meteor.Error('logic', 'Cannot revoke the application\'s owner') if User.isApplicationOwner({user, application})

		User.db.update(user['_id'],
			$pull:
				'profile.application_roles': {'application_id': application['_id']}
		)

		return
