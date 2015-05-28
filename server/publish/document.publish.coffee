Meteor.publish 'Document', ({document_id, document_schema_id, environment_id}, paging) ->
	# TODO: Check user's permissions
	# TODO: Implement paging, ordering
	if document_id
		return Document.db.find('_id': document_id)
	else
		throw new Error('Document subscription requires paging parameter') unless paging?
		throw new Error('Document subscription requires paging parameter with limit') unless _.isNumber(paging['limit'])
		throw new Error('Document subscription requires paging parameter with sort') unless _.isObject(paging['sort'])
		
		paging['limit'] = Config['MAX_TABLE_RECORDS'] if paging['limit'] > Config['MAX_TABLE_RECORDS']

		return Document.db.find({'environment_id': environment_id, 'document_schema_id': document_schema_id}, paging)
