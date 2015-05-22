Meteor.publish 'Document', ({document_id, document_schema_id, environment_id}, paging) ->
	# TODO: Check user's permissions
	# TODO: Implement paging, ordering
	if document_id
		return Document.db.find('_id': document_id)
	else
		limit = paging['page_size']
		skip = limit*(paging['page_number']-1)
		sort = {'created_on': -1}
		return Document.db.find({'environment_id': environment_id, 'document_schema_id': document_schema_id}, {limit, skip, sort})
