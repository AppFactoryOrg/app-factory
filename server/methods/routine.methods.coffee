Meteor.methods
	'Routine.execute': ({routine_id, inputs}) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', "Parameter 'routine_id' is required") if _.isEmpty(routine_id) and _.isString(routine_id)

		routine = Routine.db.findOne(routine_id)
		throw new Meteor.Error('data', 'Cannot find Routine') unless routine?

		outputs = Routine.execute(routine, inputs)
		return outputs