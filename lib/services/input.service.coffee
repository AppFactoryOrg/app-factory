RoutineService.register
	'id': 'input'
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'name': 'Input'
	'description': "An input value for the routine"
	'configuration':
		'name': ''
		'data_type': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Output'].value
		}
	]
	'execute': ({service, routineInputs}) -> 
		throw new Meteor.Error('validation', "Input service does not have a configuration") unless service['configuration']?
		
		inputData = _.find(routineInputs, {'name': service['configuration']['name']})
		throw new Meteor.Error('data', "Input service could not find required input data") unless inputData?

		value = inputData['value']

		return [{node: 'value', value: value}]