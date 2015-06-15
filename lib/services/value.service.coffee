RoutineService.register
	'id': 'value'
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'name': 'Value'
	'description': "A fixed, predefined value"
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