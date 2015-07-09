Meteor.methods
	'DocumentSchema.create': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Error('Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?
		throw new Error('Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		documentSchema = DocumentSchema.new()
		documentSchema['name'] = parameters['name']
		documentSchema['description'] = parameters['description']
		documentSchema['blueprint_id'] = blueprint['_id']
		documentSchema['_id'] = DocumentSchema.db.insert(documentSchema)

		return documentSchema['_id']

	'DocumentSchema.update': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		documentSchema = DocumentSchema.db.findOne(parameters['_id'])
		throw new Error('Cannot find Document') unless documentSchema?

		updates = _.pick(parameters, DocumentSchema.MUTABLE_PROPERTIES)
		DocumentSchema.db.update({'_id': documentSchema['_id']}, {$set: updates})

		return documentSchema['_id']

	'DocumentSchema.delete': (id) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		DocumentSchema.db.remove(id)

		return
