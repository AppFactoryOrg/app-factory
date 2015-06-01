@DocumentAttribute = 

	DATA_TYPE:
		'Text':
			value: 100
			component: 'text'
			icon: 'fa-font'

		'Number':
			value: 150
			component: 'number'
			icon: 'fa-calculator'

		'Date':
			value: 200
			component: 'date'
			icon: 'fa-calendar'

		'Option':
			value: 250
			component: 'option'
			icon: 'fa-list-ol'
			configuration:
				'options': []

		'Document':
			value: 300
			component: 'document'
			icon: 'fa-file-o'
			configuration:
				'document_schema_id': null

	VALUE_TYPE:
		'Input':			{value: 100,	icon: 'fa-edit'}
		'Routine':			{value: 200,	icon: 'fa-gear'}

	new: (parameters) ->
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
