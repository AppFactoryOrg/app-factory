@NavigationItem =
	
	TYPE:
		'Screen':	{value: 100}
		'Link':		{value: 200}

	new: (parameters) ->
		'name':				parameters['name']
		'type':				parameters['type']
		'screen_schema_id':	parameters['screen_schema_id']
		'url':				parameters['url']