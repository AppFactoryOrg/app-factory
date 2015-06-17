RoutineService.registerTemplate
	'name': 'set_attribute'
	'label': 'Set Attribute'
	'description': "Sets the value of a document's attribute"
	'color': '#837a9f'
	'display_order': 800
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration': 
		document_schema_id: ''
		attribute_id: ''
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
		return "Name"

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Set Attribute service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Set Attribute service does not have a 'value' input") unless service.inputs.hasOwnProperty('document')
		throw new Meteor.Error('validation', "Set Attribute service does not have a configuration") unless service.configuration?
		
		value = 
			attribute_id: service.configuration['attribute_id']
			value: service.inputs['value']

		return [{node: 'output', value: value}]