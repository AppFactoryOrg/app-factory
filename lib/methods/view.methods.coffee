Meteor.methods
	'View.create': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Error('Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?
		throw new Error('Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		view = View.new()
		view['name'] = parameters['name']
		view['description'] = parameters['description']
		view['widgets'] = []
		view['blueprint_id'] = blueprint['_id']
		view['_id'] = View.db.insert(view)

		return view['_id']

	'View.update': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		view = View.db.findOne(parameters['_id'])
		throw new Error('Cannot find View') unless view?

		updates = _.pick(parameters, View.MUTABLE_PROPERTIES)
		View.db.update({'_id': view['_id']}, {$set: updates})

		return view['_id']

	'View.delete': (id) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		View.db.remove(id)

		return