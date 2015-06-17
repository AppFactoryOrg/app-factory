RoutineService.registerTemplate
	'name': 'get_attribute'
	'label': 'Get Attribute'
	'description': "Gets the value of a document's attribute"
	'color': '#837a9f'
	'display_order': 700
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration': 
		'attribute_id': ''
		'document_schema_id': ''
	'nodes': [
		{
			name: 'document'
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
		throw new Meteor.Error('validation', "Get Attribute service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Get Attribute service does not have a 'document' input") unless service.inputs.hasOwnProperty('document')
		throw new Meteor.Error('validation', "Get Attribute service does not have a configuration") unless service.configuration?
		
		document = service.inputs['document']
		attribute_id = service.configuration['attribute_id']
		value = document['data'][attribute_id]

		return [{node: 'output', value: value}]