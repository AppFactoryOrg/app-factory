@Application =

	db: new Mongo.Collection('application')

	MUTABLE_PROPERTIES: [
		'name'
	]

	new: ->
		application =
			'name': 					null
			'enabled': 					null
			'owner_id': 				null
			'default_environment_id':	null
			'metadata':
				'user_count':
					'value': 0
					'updated_on': null
				'db_size':
					'value': 0
					'updated_on': null
			'limits':
				'max_users': null
				'max_db': null

		if Meteor.settings.public.application_limits.should_enforce
			application['limits']['max_users'] = Meteor.settings.public.application_limits.default_max_users
			application['limits']['max_db'] = Meteor.settings.public.application_limits.default_max_db

		return application

	updateUserCount: (application_id) ->
		return unless Meteor.isServer
		throw new Error('Application ID is required') unless application_id?

		count = User.db.find({'profile.application_roles.application_id': application_id}).count()

		updates =
			'metadata.user_count.value': count
			'metadata.user_count.updated_on': Date.now()

		Application.db.update(application_id, {$set: updates})

		return

	updateDbSize: (application_id) ->
		return unless Meteor.isServer
		throw new Error('Application ID is required') unless application_id?

		environments = Environment.db.find({'application_id': application_id}).fetch()
		environment_ids = _.pluck(environments, '_id')

		size = Document.db.aggregate([
			{$match: {'environment_id': {$in: environment_ids}}}
			{$group: {_id: null, totalSize: {$sum: "$size"}}}
		])

		updates =
			'metadata.db_size.value': size[0]['totalSize']
			'metadata.db_size.updated_on': Date.now()

		Application.db.update(application_id, {$set: updates})

		return
