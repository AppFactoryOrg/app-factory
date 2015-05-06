Meteor.publish 'Environment', ({environment_id, application_id}) ->
	# TODO: Check user's permissions
	if environment_id
		return Environment.db.find('_id': environment_id)
	else
		return Environment.db.find('application_id': application_id)
