Meteor.methods
	'Blueprint.update': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), parameters['_id'], true)
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?

		blueprint = Blueprint.db.findOne(parameters['_id'])
		throw new Meteor.Error('validation', 'Cannot find Blueprint') unless blueprint?

		updates = _.pick(parameters, Blueprint.MUTABLE_PROPERTIES)
		Blueprint.db.update({'_id': blueprint['_id']}, {$set: updates})

		return blueprint['_id']
