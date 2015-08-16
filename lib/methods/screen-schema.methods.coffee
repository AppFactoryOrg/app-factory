Meteor.methods
	'ScreenSchema.create': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), parameters['blueprint_id'], true)
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?
		throw new Meteor.Error('validation', 'Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Meteor.Error('validation', 'Cannot find Blueprint') unless blueprint?
		throw new Meteor.Error('validation', 'Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		screenSchema = ScreenSchema.new()
		screenSchema['name'] = parameters['name']
		screenSchema['description'] = parameters['description']
		screenSchema['widgets'] = []
		screenSchema['blueprint_id'] = blueprint['_id']
		screenSchema['_id'] = ScreenSchema.db.insert(screenSchema)

		return screenSchema['_id']

	'ScreenSchema.update': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), parameters['blueprint_id'], true)
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?

		screenSchema = ScreenSchema.db.findOne(parameters['_id'])
		throw new Meteor.Error('validation', 'Cannot find ScreenSchema') unless screenSchema?

		updates = _.pick(parameters, ScreenSchema.MUTABLE_PROPERTIES)
		ScreenSchema.db.update({'_id': screenSchema['_id']}, {$set: updates})

		return screenSchema['_id']

	'ScreenSchema.delete': (id) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Id is required') if _.isEmpty(id) and _.isString(id)

		screenSchema = ScreenSchema.db.findOne(id)
		throw new Meteor.Error('validation', 'Cannot find ScreenSchema') unless screenSchema?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), screenSchema['blueprint_id'], true)

		ScreenSchema.db.remove(id)

		return
