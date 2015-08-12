@Application =

	db: new Mongo.Collection('application')

	MUTABLE_PROPERTIES: [
		'name'
	]

	new: ->
		'name': 					null
		'enabled': 					null
		'owner_id': 				null
		'default_environment_id':	null
		'metadata':
			'user_count':
				'value': 0
				'updated_on': null

	updateUserCount: (application_id) ->
		return unless Meteor.isServer
		throw new Error('Application ID is required') unless application_id?

		count = User.db.find({'profile.application_roles.application_id': application_id}).count()

		updates =
			'metadata.user_count.value': count
			'metadata.user_count.updated_on': Date.now()

		Application.db.update(application_id, {$set: updates})

		return
