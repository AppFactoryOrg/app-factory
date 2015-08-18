Meteor.publish 'DocumentSchemas', ({blueprint_id}) ->
	throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(@userId, blueprint_id)
	return DocumentSchema.db.find('blueprint_id': blueprint_id)
