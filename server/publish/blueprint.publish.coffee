Meteor.publish 'Blueprint', ({blueprint_id}) ->
	# TODO: Check user's permissions
	return Blueprint.db.find('_id': blueprint_id)
