Meteor.publish 'Document', (document_id) ->
	return Document.db.find('_id': document_id)

Meteor.publishComposite 'Documents', ({document_schema_id, environment_id}, paging) ->
	documentSchema = DocumentSchema.db.findOne(document_schema_id)
	childDocumentAttributesId = _.pluck(_.filter(documentSchema['attributes'], {'data_type': DocumentAttribute.DATA_TYPE['Document'].value}), 'id')

	return {
		find: ->
			throw new Error('Document subscription requires paging parameter') unless paging?
			throw new Error('Document subscription requires paging parameter with limit') unless _.isNumber(paging['limit'])
			throw new Error('Document subscription requires paging parameter with sort') unless _.isObject(paging['sort'])
			
			paging['limit'] = Config['MAX_TABLE_RECORDS'] if paging['limit'] > Config['MAX_TABLE_RECORDS']

			return Document.db.find({'environment_id': environment_id, 'document_schema_id': document_schema_id}, paging)

		children: [
			{
				find: (document) ->
					childDocumentIds = _.values(_.pick(document['data'], childDocumentAttributesId))
					return if _.isEmpty(childDocumentIds)
					return Document.db.find({'_id': {'$in': childDocumentIds}})
			}
		]
	}