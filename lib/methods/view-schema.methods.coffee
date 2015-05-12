Meteor.methods
	'ViewSchema.create': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Error('Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?
		throw new Error('Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		viewWidget = ViewWidget.new()
		viewWidget['id'] = 1
		viewWidget['name'] = 'View Container'
		viewWidget['type'] = ViewWidget.TYPE['Container'].value

		viewSchema = ViewSchema.new()
		viewSchema['name'] = parameters['name']
		viewSchema['description'] = parameters['description']
		viewSchema['widgets'] = [viewWidget]
		viewSchema['blueprint_id'] = blueprint['_id']
		viewSchema['_id'] = ViewSchema.db.insert(viewSchema)

		return viewSchema['_id']

	'ViewSchema.update': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		viewSchema = ViewSchema.db.findOne(parameters['_id'])
		throw new Error('Cannot find ViewSchema') unless viewSchema?

		updates = _.pick(parameters, ViewSchema.MUTABLE_PROPERTIES)
		ViewSchema.db.update({'_id': viewSchema['_id']}, {$set: updates})

		return viewSchema['_id']

	'ViewSchema.delete': (id) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		ViewSchema.db.remove(id)

		return