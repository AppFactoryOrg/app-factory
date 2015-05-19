@NavigationItem =
	
	TYPE:
		'View':		{value: 100}
		'Link':		{value: 200}

	new: (parameters) ->
		'name':				parameters['name']
		'type':				parameters['type']
		'view_schema_id':	null
		'url':				null