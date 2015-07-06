Meteor.methods
	'ScreenSchema.create': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Error('Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?
		throw new Error('Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		screenSchema = ScreenSchema.new()
		screenSchema['name'] = parameters['name']
		screenSchema['description'] = parameters['description']
		screenSchema['widgets'] = []
		screenSchema['blueprint_id'] = blueprint['_id']
		screenSchema['_id'] = ScreenSchema.db.insert(screenSchema)

		return screenSchema['_id']

	'ScreenSchema.update': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		screenSchema = ScreenSchema.db.findOne(parameters['_id'])
		throw new Error('Cannot find ScreenSchema') unless screenSchema?

		updates = _.pick(parameters, ScreenSchema.MUTABLE_PROPERTIES)
		ScreenSchema.db.update({'_id': screenSchema['_id']}, {$set: updates})

		return screenSchema['_id']

	'ScreenSchema.delete': (id) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		ScreenSchema.db.remove(id)

		return
