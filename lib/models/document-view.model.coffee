@DocumentView =

	new: (parameters) ->
		'id':				Meteor.uuid()
		'widget':			parameters['widget']
		'filter':			parameters['filter']
