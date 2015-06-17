RoutineService.registerTemplate
	'name': 'value'
	'label': 'Value'
	'description': "A fixed, predefined value"
	'color': '#837a9f'
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration': 
		'value': null
		'data_type': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Output'].value
			position: 'Right'
		}
	]
	
	describeConfiguration: (service) ->
		return "Type"

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Value service does not have a configuration") unless service['configuration']?
		
		value = service['configuration']['value']
		
		return [{node: 'value', value: value}]