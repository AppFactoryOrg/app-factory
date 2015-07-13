Meteor.publish 'Document', (document_id) ->
	return Document.db.find('_id': document_id)

Meteor.publishComposite 'Documents', (filter, paging) -> Utils.logErrors ->
	throw new Error('Filter parameter is required') unless filter?
	throw new Error('Filter parameter requires environment_id attribute') unless filter['environment_id']?
	throw new Error('Filter parameter requires document_schema_id attribute') unless filter['document_schema_id']?

	environment = Environment.db.findOne(filter['environment_id'])
	throw new Meteor.Error('data', 'Could not find environment for Document publishing.') unless environment?

	application = Application.db.findOne(environment['application_id'])
	throw new Meteor.Error('data', 'Could not find application for Document publishing.') unless application?
	throw new Meteor.Error('limitation', 'Could not publish Documents because the application is disabled.') if application['enabled'] is false

	documentSchema = DocumentSchema.db.findOne(filter['document_schema_id'])
	childDocumentAttributeIds = _.pluck(_.filter(documentSchema['attributes'], {'data_type': DocumentAttribute.DATA_TYPE['Document'].value}), 'id')
	childUserAttributeIds = _.pluck(_.filter(documentSchema['attributes'], {'data_type': DocumentAttribute.DATA_TYPE['User'].value}), 'id')

	return {
		find: ->
			paging = {'limit': Config['MAX_TABLE_RECORDS']} unless paging?
			paging['limit'] = Config['MAX_TABLE_RECORDS'] if paging['limit'] > Config['MAX_TABLE_RECORDS']
			return Document.db.find(filter, paging)

		children: [
			{
				find: (document) ->
					childDocumentIds = _.values(_.pick(document['data'], childDocumentAttributeIds))
					return if _.isEmpty(childDocumentIds)
					return Document.db.find({'_id': {'$in': childDocumentIds}})
			}
			{
				find: (document) ->
					childUserIds = _.values(_.pick(document['data'], childUserAttributeIds))
					return if _.isEmpty(childUserIds)

					filters =
						'_id': {'$in': childUserIds}

					fields =
						'_id': 1
						'profile': 1
						'emails': 1

					return User.db.find(filters, {fields})
			}
		]
	}
