Meteor.publish 'ViewSchema', ({view_schema_id, blueprint_id}) ->
	# TODO: Check user's permissions
	if view_schema_id
		return ViewSchema.db.find('_id': view_schema_id)
	else
		return ViewSchema.db.find('blueprint_id': blueprint_id)