Meteor.publish 'Application', (application_id) ->
	return Application.db.find('_id': application_id)

Meteor.publish 'Applications', (application_ids) ->
	user = User.db.findOne(@userId)
	return unless user?
	
	application_ids = _.intersection(application_ids, _.pluck(user['profile']['application_roles'], 'application_id'))
	return Application.db.find('_id': {'$in': application_ids})
