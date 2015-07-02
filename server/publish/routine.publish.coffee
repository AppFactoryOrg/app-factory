Meteor.publish 'Routine', ({routine_id}) ->
	return Routine.db.find('_id': routine_id)

Meteor.publish 'Routines', ({blueprint_id}) ->
	return Routine.db.find('blueprint_id': blueprint_id)