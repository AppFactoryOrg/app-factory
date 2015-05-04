Meteor.publish 'Application', (application_id) ->
	# TODO: Check user's permission to access application
	if application_id
		return Application.db.find('_id': application_id)
	else
		return Application.db.find('owner_id': @userId)