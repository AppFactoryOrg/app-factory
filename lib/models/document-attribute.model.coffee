@DocumentAttribute = 

	DATA_TYPE:
		'Text':				{value: 100,		icon: 'fa-font'}
		'Content':			{value: 125,		icon: 'fa-paragraph'}
		'Number':			{value: 150,		icon: 'fa-calculator'}
		'Date':				{value: 200,		icon: 'fa-calendar'}
		'Duration':			{value: 225,		icon: 'fa-clock'}
		'Currency':			{value: 250,		icon: 'fa-dollar'}
		'Document':			{value: 300,		icon: 'fa-file-o'}
		'User':				{value: 350,		icon: 'fa-user'}
		'Image':			{value: 400,		icon: 'fa-image'}
		'Coordinates':		{value: 450,		icon: 'fa-map'}
		'Address':			{value: 500,		icon: 'fa-home'}
		'Phone Number':		{value: 550,		icon: 'fa-phone'}
		'Email':			{value: 600,		icon: 'fa-at'}

	VALUE_TYPE:
		'Input':			{value: 100,		icon: 'fa-edit'}
		'Routine':			{value: 200,		icon: 'fa-gear'}

	new: ->
		'name':						null
		'value_type':				null
		'input_type':				null
		'default_value':			null
		'routine_id':				null

	hasDefaultValue: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
		return false

	hasRoutineId: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Routine'].value
		return false
