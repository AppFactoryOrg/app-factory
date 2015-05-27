Meteor.publish 'ScreenSchema', ({screen_schema_id, blueprint_id}) ->
	# TODO: Check user's permissions
	if screen_schema_id
		return ScreenSchema.db.find('_id': screen_schema_id)
	else
		return ScreenSchema.db.find('blueprint_id': blueprint_id)