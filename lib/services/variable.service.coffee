RoutineService.registerTemplate
	'name': 'variable'
	'label': 'Variable'
	'description': "Defines a variable for a value"
	'color': '#837a9f'
	'display_order': 600
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
	'flags': []
	'nodes': [
		{
			name: 'value'
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
		throw new Meteor.Error('validation', "Define Variable service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Define Variable service does not have a 'value' input") unless service_inputs['value']?
		throw new Meteor.Error('validation', "Define Variable service does not have a configuration") unless service['configuration']?

		value = service_inputs['value']?['value']
		value = value ? null

		return [{
			node: 'output'
			output:
				value: value
				name: service['configuration']['name']
		}]
