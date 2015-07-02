RoutineService.registerTemplate
	'name': 'check'
	'label': 'Check'
	'description': "Checks if the input for having/not having a value"
	'color': '#64adc9'
	'display_order': 470
	'size': {height: 50, width: 110}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'flags': []
	'configuration':
		'operator': null
	'meta_data':
		'operators': {'has value', 'no value'}
	'nodes': [
		{
			name: 'input'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.5, -1, 0]
		}
		{
			name: 'result'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.5, 1, 0]
		}
	]

	describeConfiguration: (service) ->
		return service['configuration']['operator']

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Check service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Check service does not have an input") unless service_inputs['input']?
		throw new Meteor.Error('validation', "Check service does not have an operator configured") unless service['configuration']['operator']?

		value = service_inputs['input']['value']
		operator = service['configuration']['operator']

		if operator is 'has value'
			result = value?
		else if operator is 'no value'
			result = not value?
		else
			result = false

		return [{
			node: 'result'
			output:
				value: result
		}]
