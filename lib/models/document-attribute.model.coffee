@DocumentAttribute =

	DATA_TYPE:
		'Text':
			value: 100
			component: 'text'
			icon: 'fa-font'
			operators: {'is', 'contains'}
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isString(value)
				return 'is too long' if value.length > Config['MAX_TEXT_LENGTH']
				return true

		'Number':
			value: 150
			component: 'number'
			icon: 'fa-calculator'
			operators: {'=', '>', '>=', '<', '<=', 'between'}
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isNumber(value)
				return 'is too long' if value.length > Config['MAX_NUMBER_LENGTH']
				return true

		'Date':
			value: 200
			component: 'date'
			icon: 'fa-calendar'
			operators: {'on', 'before', 'after', 'between'}
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isNumber(value)
				return 'is too long' if value.length > Config['MAX_DATE_LENGTH']
				return true

		'Option':
			value: 250
			component: 'option'
			icon: 'fa-list-ol'
			operators: {'is'}
			configuration:
				'options': []
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isString(value)
				return 'is too long' if value.length > Config['MAX_OPTION_LENGTH']
				return true

		'Document':
			value: 300
			component: 'document'
			icon: 'fa-file-o'
			data_dependent: true
			operators: {'is'}
			configuration:
				'document_schema_id': null
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isString(value)
				return 'is too long' if value.length > Config['MAX_DOCUMENT_ID_LENGTH']
				return true

		'Collection':
			value: 400
			component: 'collection'
			icon: 'fa-files-o'
			data_dependent: true
			operators: {'contains'}
			configuration:
				'document_schema_id': null
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isArray(value)
				return 'has too many items' if value.length > Config['MAX_COLLECTION_LENGTH']
				return true

		'User':
			value: 500
			component: 'User'
			operators: {'is'}
			icon: 'fa-user'
			isValid: (value) ->
				return true if value is null
				return 'is not the proper data type' unless _.isString(value)
				return 'is too long' if value.length > Config['MAX_USER_ID_LENGTH']
				return true

	VALUE_TYPE:
		'Input':			{value: 100,	icon: 'fa-edit'}
		'Routine':			{value: 200,	icon: 'fa-gear'}

	new: (parameters) ->
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': parameters['data_type'])
		throw new Error('Unrecognized DocumentAttribute.DATA_TYPE specified') unless type?

		'id':				Meteor.uuid()
		'name':				parameters['name']
		'data_key':			null
		'data_type':		parameters['data_type']
		'value_type':		parameters['value_type']
		'default_value':	parameters['default_value']
		'routine_id':		parameters['routine_id']
		'configuration':	_.extend(_.clone(type['configuration']), parameters['configuration'])

	getDataType: (value) ->
		data_type = _.find(DocumentAttribute.DATA_TYPE, {value})
		return data_type

	getDataKey: (attribute) ->
		if attribute['data_key']?
			return attribute['data_key']
		else
			return "data.#{attribute['id']}"

	getCreatedByAsAttribute: ->
		'id': 'created_by'
		'name': 'Created By'
		'data_key': 'created_by'
		'data_type': DocumentAttribute.DATA_TYPE['User'].value
		'value_type': DocumentAttribute.VALUE_TYPE['Input'].value

	getCreatedOnAsAttribute: ->
		'id': 'created_on'
		'name': 'Created On'
		'data_key': 'created_on'
		'data_type': DocumentAttribute.DATA_TYPE['Date'].value
		'value_type': DocumentAttribute.VALUE_TYPE['Input'].value

	hasDefaultValue: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
		return false

	hasRoutineId: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Routine'].value
		return false

	compare: ({value_a, value_b, data_type, operator}) ->
		return false unless value_a? and value_b? and data_type? and operator?

		data_type =  DocumentAttribute.getDataType(data_type)

		switch data_type
			when DocumentAttribute.DATA_TYPE['Text']
				return false unless _.isString(value_a) and _.isString(value_b)
				switch operator
					when data_type['operators']['is']
						return value_a is value_b
					when data_type['operators']['contains']
						return value_a.indexOf(value_b) > -1

			when DocumentAttribute.DATA_TYPE['Number']
				return false unless _.isNumber(value_a) and _.isNumber(value_b)
				switch operator
					when data_type['operators']['=']
						return value_a is value_b
					when data_type['operators']['>']
						return value_a > value_b
					when data_type['operators']['>=']
						return value_a >= value_b
					when data_type['operators']['<']
						return value_a < value_b
					when data_type['operators']['<=']
						return value_a <= value_b

			when DocumentAttribute.DATA_TYPE['Date']
				return false unless _.isNumber(value_a) and _.isNumber(value_b)
				switch operator
					when data_type['operators']['on']
						return value_a is value_b
					when data_type['operators']['before']
						return value_a < value_b
					when data_type['operators']['after']
						return value_a > value_b

			when DocumentAttribute.DATA_TYPE['Option']
				return false unless _.isString(value_a) and _.isString(value_b)
				switch operator
					when data_type['operators']['is']
						return value_a is value_b

			when DocumentAttribute.DATA_TYPE['Document']
				return false unless _.isString(value_a) and _.isString(value_b)
				switch operator
					when data_type['operators']['is']
						return value_a is value_b

			when DocumentAttribute.DATA_TYPE['Collection']
				return false unless _.isArray(value_a) and _.isString(value_b)
				switch operator
					when data_type['operators']['contains']
						return _.contains(value_a, value_b)

			when DocumentAttribute.DATA_TYPE['User']
				return false unless _.isString(value_a) and _.isString(value_b)
				switch operator
					when data_type['operators']['is']
						return value_a is value_b

		return false

	validate: (attribute, attribute_value) ->
		data_type =  DocumentAttribute.getDataType(attribute['data_type'])
		return data_type.isValid(attribute_value)
