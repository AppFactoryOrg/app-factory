RoutineService.registerTemplate
	'name': 'get_output'
	'label': 'Get Output'
	'description': "Retrieves output from a Routine service"
	'color': '#837a9f'
	'display_order': 690
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'output_name': ''
	'flags': []
	'nodes': [
		{
			name: 'input'
			type: RoutineService.NODE_TYPE['Input'].value
			position: 'Left'
		}
		{
			name: 'output'
			type: RoutineService.NODE_TYPE['Output'].value
			position: 'Right'
		}
	]

	describeConfiguration: (service) ->
		return unless service?
		name = service['configuration']['name']
		return "#{name}"

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Get Output service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Get Output service does not have a input") unless service_inputs['input']?
		throw new Meteor.Error('validation', "Get Output service does not have a 'Name' configuration") unless service['configuration']['name']?
		throw new Meteor.Error('validation', "Get Output service does not have an 'Output Name' configuration") unless service['configuration']['output_name']?

		routine_outputs = service_inputs['input']
		output = _.findWhere(routine_outputs, {'name': service['configuration']['output_name']})
		throw new Meteor.Error('logic', "Get Output service cannot find the specified output") unless output?

		value = output['value']

		return [{
			node: 'output'
			output:
				value: value
				name: service['configuration']['name']
		}]
