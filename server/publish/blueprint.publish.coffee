Meteor.publish 'Blueprint', ({blueprint_id}) ->
	throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(@userId, blueprint_id)
	return Blueprint.db.find('_id': blueprint_id)
