RoutineService.registerTemplate
	'name': 'value'
	'label': 'Value'
	'description': "A fixed, predefined value"
	'color': '#70678E'
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration': 
		'value': null
		'data_type': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Output'].value
		}
	]
	'execute': ({service}) ->
		throw new Meteor.Error('validation', "Value service does not have a configuration") unless service['configuration']?
		
		value = service['configuration']['value']
		
		return [{node: 'value', value: value}]