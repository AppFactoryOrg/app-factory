@DocumentAction = 

	new: (parameters) ->
		'id':				Meteor.uuid()
		'name':				parameters['name']
		'routine_id':		parameters['routine_id']