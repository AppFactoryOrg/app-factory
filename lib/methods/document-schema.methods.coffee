Meteor.methods
	'DocumentSchema.create': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Error('Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?
		throw new Error('Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft']

		documentSchema = DocumentSchema.new()
		documentSchema['name'] = parameters['name']
		documentSchema['blueprint_id'] = blueprint['_id']
		documentSchema['_id'] = DocumentSchema.db.insert(documentSchema)

		return documentSchema['_id']