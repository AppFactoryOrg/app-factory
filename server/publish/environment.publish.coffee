Meteor.publish 'Environment', (environment_id) ->
	throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessEnvironment(@userId, environment_id)
	return Environment.db.find('_id': environment_id)
