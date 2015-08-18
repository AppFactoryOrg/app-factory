Meteor.publish 'ScreenSchemas', ({blueprint_id}) ->
	throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(@userId, blueprint_id)
	return ScreenSchema.db.find('blueprint_id': blueprint_id)
