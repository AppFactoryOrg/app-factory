Meteor.publish 'Application', (application_id) ->
	if application_id
		return Application.db.find('_id': application_id)
	else
		user = User.db.findOne(@userId)
		applicationIds = _.pluck(user['profile']['application_roles'], 'application_id')
		return Application.db.find('_id': {'$in': applicationIds})