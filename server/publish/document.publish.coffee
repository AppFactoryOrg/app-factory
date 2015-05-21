Meteor.publish 'Document', ({document_id, environment_id}) ->
	# TODO: Check user's permissions
	# TODO: Implement paging, ordering
	if document_id
		return DocumentSchema.db.find('_id': document_id)
	else
		return DocumentSchema.db.find('environment_id': environment_id)