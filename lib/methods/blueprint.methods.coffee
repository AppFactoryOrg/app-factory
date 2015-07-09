Meteor.methods
	'Blueprint.update': (parameters) -> Utils.logErrors ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		blueprint = Blueprint.db.findOne(parameters['_id'])
		throw new Error('Cannot find Blueprint') unless blueprint?

		updates = _.pick(parameters, Blueprint.MUTABLE_PROPERTIES)
		Blueprint.db.update({'_id': blueprint['_id']}, {$set: updates})

		return blueprint['_id']
