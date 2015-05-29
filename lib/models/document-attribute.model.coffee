@DocumentAttribute = 

	DATA_TYPE:
		'Text':
			value: 100
			component: 'text'
			icon: 'fa-font'

		'Content':
			value: 125
			component: 'content'
			icon: 'fa-paragraph'

		'Number':
			value: 150
			component: 'number'
			icon: 'fa-calculator'
			configuration: 
				'format': null

		'Date':				
			value: 200
			component: 'date'
			icon: 'fa-calendar'

		'Duration':			
			value: 225
			component: 'duration'
			icon: 'fa-clock'

		'Document':			
			value: 300
			component: 'document'
			icon: 'fa-file-o'

		'User':				
			value: 350
			component: 'user'
			icon: 'fa-user'

		'Image':			
			value: 400
			component: 'image'
			icon: 'fa-image'

		'Coordinates':		
			value: 450
			component: 'coordinates'
			icon: 'fa-map'

		'Address':			
			value: 500
			component: 'address'
			icon: 'fa-home'

		'Phone Number':		
			value: 550
			component: 'phonenumber'
			icon: 'fa-phone'

		'Email':			
			value: 600
			component: 'email'
			icon: 'fa-at'

	VALUE_TYPE:
		'Input':			{value: 100,	icon: 'fa-edit'}
		'Routine':			{value: 200,	icon: 'fa-gear'}

	new: (parameters) ->
		debugger
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': parameters['data_type'])
		throw new Error('Unrecognized DocumentAttribute.DATA_TYPE specified') unless type?

		'id':				Meteor.uuid()
		'name':				parameters['name']
		'data_type':		parameters['data_type']
		'value_type':		parameters['value_type']
		'default_value':	parameters['default_value']
		'routine_id':		parameters['routine_id']
		'configuration':	_.extend(_.clone(type['configuration']), parameters['configuration'])

	hasDefaultValue: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
		return false

	hasRoutineId: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Routine'].value
		return false
