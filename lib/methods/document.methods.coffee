Meteor.methods
	'Document.create': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "document_schema_id" is required') if _.isEmpty(parameters['document_schema_id'])
		throw new Error('Parameter "environment_id" is required') if _.isEmpty(parameters['environment_id'])

		documentSchema = DocumentSchema.db.findOne(parameters['document_schema_id'])
		throw new Error('Cannot find DocumentSchema for new Document') unless documentSchema?

		environment = Environment.db.findOne(parameters['environment_id'])
		throw new Error('Cannot find Environment for new Document') unless environment?

		document = Document.new(parameters)
		document['_id'] = Document.db.insert(document) 

		return document['_id']

	'Document.update': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		document = Document.db.findOne(parameters['_id'])
		throw new Error('Cannot find Document') unless document?

		updates = _.pick(parameters, Document.MUTABLE_PROPERTIES)
		Document.db.update({'_id': document['_id']}, {$set: updates})

		return document['_id']

	'Document.delete': (id) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		document = Document.db.findOne(id)
		throw new Error('Cannot find Document') unless document?

		Document.db.remove(document['_id'])

		return