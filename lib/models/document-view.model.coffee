@DocumentView =

	new: (parameters) ->
		'id':				Meteor.uuid()
		'widget':			parameters['widget']
