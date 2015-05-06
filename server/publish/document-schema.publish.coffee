Meteor.publish 'DocumentSchema', ({document_schema_id, blueprint_id}) ->
	# TODO: Check user's permissions
	if document_schema_id
		return DocumentSchema.db.find('_id': document_schema_id)
	else
		return DocumentSchema.db.find('blueprint_id': blueprint_id)