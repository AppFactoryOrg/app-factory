RoutineService.registerTemplate
	'name': 'value'
	'label': 'Value'
	'description': "A fixed, predefined value"
	'color': '#837a9f'
	'display_order': 500
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration': 
		'name': ''
		'value': null
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

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Value service does not have a configuration") unless service['configuration']?
		
		value = service['configuration']['value']
		
		return [{node: 'value', value: value}]