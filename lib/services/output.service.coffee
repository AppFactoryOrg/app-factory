RoutineService.registerTemplate
	'name': 'output'
	'label': 'Output'
	'description': "An output value for the routine"
	'color': '#df706c'
	'display_order': 400
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'data_type': null
		'document_schema_id': null
	'flags': []
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Input'].value
			position: 'Left'
		}
	]

	describeConfiguration: (service) ->
		return unless service?
		type = service['configuration']['data_type']
		if type?
			type = _.findWhere(Utils.mapToArray(DocumentAttribute.DATA_TYPE), {'value': type})
			return "#{type.name}"
		else
			return ""

	execute: -> 
		return []