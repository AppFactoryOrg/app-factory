Meteor.publish 'Document', ({document_id, document_schema_id, environment_id}, paging) ->
	# TODO: Check user's permissions
	# TODO: Implement paging, ordering
	if document_id
		return Document.db.find('_id': document_id)
	else
		return Document.db.find({'environment_id': environment_id, 'document_schema_id': document_schema_id}, paging)
