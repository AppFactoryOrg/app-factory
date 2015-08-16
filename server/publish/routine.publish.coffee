Meteor.publish 'Routines', ({blueprint_id}) ->
	throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(@userId, blueprint_id)
	return Routine.db.find('blueprint_id': blueprint_id)
