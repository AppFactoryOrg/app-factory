Meteor.methods
	'Routine.create': (parameters) -> Utils.logErrors ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?
		throw new Meteor.Error('validation', 'Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Parameter "type" is required') unless _.isNumber(parameters['type'])
		throw new Meteor.Error('validation', 'Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Meteor.Error('data', 'Cannot find Blueprint') unless blueprint?
		throw new Meteor.Error('logic', 'Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		routine = Routine.new(parameters)
		routine['_id'] = Routine.db.insert(routine)

		return routine['_id']

	'Routine.update': (parameters) -> Utils.logErrors ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?

		routine = Routine.db.findOne(parameters['_id'])
		throw new Meteor.Error('data', 'Cannot find Routine') unless routine?

		updates = _.pick(parameters, Routine.MUTABLE_PROPERTIES)
		Routine.db.update({'_id': routine['_id']}, {$set: updates})

		return routine['_id']

	'Routine.delete': (id) -> Utils.logErrors ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Id is required') if _.isEmpty(id) and _.isString(id)

		Routine.db.remove(id)

		return
