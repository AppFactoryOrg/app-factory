@DocumentAttribute = 

	DATA_TYPE:
		'Text':				{value: 100,	component: 'text',			icon: 'fa-font'}
		'Content':			{value: 125,	component: 'content',		icon: 'fa-paragraph'}
		'Number':			{value: 150,	component: 'number',		icon: 'fa-calculator'}
		'Date':				{value: 200,	component: 'date',			icon: 'fa-calendar'}
		'Duration':			{value: 225,	component: 'duration',		icon: 'fa-clock'}
		'Currency':			{value: 250,	component: 'currency',		icon: 'fa-dollar'}
		'Document':			{value: 300,	component: 'document',		icon: 'fa-file-o'}
		'User':				{value: 350,	component: 'user',			icon: 'fa-user'}
		'Image':			{value: 400,	component: 'image',			icon: 'fa-image'}
		'Coordinates':		{value: 450,	component: 'coordinates',	icon: 'fa-map'}
		'Address':			{value: 500,	component: 'address',		icon: 'fa-home'}
		'Phone Number':		{value: 550,	component: 'phonenumber',	icon: 'fa-phone'}
		'Email':			{value: 600,	component: 'email',			icon: 'fa-at'}

	VALUE_TYPE:
		'Input':			{value: 100,	icon: 'fa-edit'}
		'Routine':			{value: 200,	icon: 'fa-gear'}

	new: ->
		'id':				Meteor.uuid()
		'name':				null
		'data_type':		null
		'value_type':		null
		'default_value':	null
		'routine_id':		null

	hasDefaultValue: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
		return false

	hasRoutineId: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Routine'].value
		return false
