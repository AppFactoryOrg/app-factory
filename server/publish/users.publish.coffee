Meteor.publish 'User', ({user_id}) ->
	filters =
		'_id': user_id

	fields =
		'_id': 1
		'profile': 1
		'emails': 1

	return User.db.find(filters, {fields})

Meteor.publish 'Users', ({application_id}) ->
	filters =
		'profile.application_roles.application_id': application_id

	fields =
		'_id': 1
		'profile': 1
		'emails': 1

	return User.db.find(filters, {fields})

Meteor.users.deny(
	update: -> return false
)
