RoutineService.registerTemplate
	'name': 'input'
	'label': 'Input'
	'description': "An input value for the routine"
	'color': '#77C777'
	'display_order': 200
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'data_type': null
		'document_schema_id': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Output'].value
			position: 'Right'
		}
	]

	describeConfiguration: (service) ->
		return unless service?
		name = service['configuration']['name']
		return "#{name}"

	execute: ({service, routineInputs}) -> 
		throw new Meteor.Error('validation', "Input service does not have a configuration") unless service['configuration']?
		
		inputData = _.find(routineInputs, {'name': service['configuration']['name']})
		throw new Meteor.Error('data', "Input service could not find required input data") unless inputData?

		value = inputData['value']

		return [{node: 'value', value: value}]