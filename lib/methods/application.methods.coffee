Meteor.methods
	'Application.create': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])

		application = Application.new()
		application['name'] = parameters['name']
		application['enabled'] = true
		application['owner_id'] = Meteor.userId()
		application['_id'] = Application.db.insert(application)

		blueprint = Blueprint.new()
		blueprint['version'] = '1.0.0'
		blueprint['status'] = Blueprint.STATUS['Draft'].value
		blueprint['application_id'] = application['_id']
		blueprint['_id'] = Blueprint.db.insert(blueprint)

		environment = Environment.new()
		environment['name'] = 'Development'
		environment['type'] = Environment.TYPE['Development']
		environment['application_id'] = application['_id']
		environment['blueprint_id'] = blueprint['_id']
		environment['_id'] = Environment.db.insert(environment)

		Application.db.update(application['_id'],
			$set:
				'default_environment_id': environment['_id']
		)

		User.db.update(Meteor.userId(),
			$addToSet:
				'profile.application_roles':
					'application_id': application['_id']
					'role': User.ROLE['Owner'].value
					'can_edit': true
		)

		return application['_id']

	'Application.update': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		application = Application.db.findOne(parameters['_id'])
		throw new Error('Cannot find Application') unless application?

		updates = _.pick(parameters, Application.MUTABLE_PROPERTIES)
		Application.db.update({'_id': application['_id']}, {$set: updates})

		return application['_id']
