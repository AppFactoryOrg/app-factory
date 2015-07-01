RoutineService.registerTemplate
	'name': 'create_document'
	'label': 'Create Document'
	'description': "Creates a document with the specified attributes"
	'color': '#567CA0'
	'display_order': 50200
	'size': {height: 80, width: 150}
	'flags': ['modifies_db']
	'configuration':
		'name': ''
		'document_schema_id': null
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: [0, 0.25, -1, 0]
		}
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
			position: [1, 0.25, 1, 0]
		}
		{
			name: 'attributes'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input-multiple'
			multiple: true
			position: [0, 0.75, -1, 0]
			label: 'Attributes'
			labelPosition: [2.8, 0.5]
		}
		{
			name: 'reference'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.75, 1, 0]
			label: 'Reference'
			labelPosition: [-1.85, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs, environment_id}) ->
		throw new Meteor.Error('validation', "Create Document service does not have an Environment specified") unless environment_id?
		throw new Meteor.Error('validation', "Create Document service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Create Document service does not have an 'Attributes' input") unless service_inputs['attributes']?
		throw new Meteor.Error('validation', "Create Document service does not have a 'Document Type' configured") unless service['configuration']['document_schema_id']?

		attributes = {}
		service_inputs['attributes'].forEach (attribute) ->
			attribute_content = attribute['value']
			id = attribute_content['attribute_id']
			value = attribute_content['value']
			attributes[id] = value

		parameters =
			'data': attributes
			'document_schema_id': service['configuration']['document_schema_id']
			'environment_id': environment_id

		reference = Meteor.call('Document.create', parameters)

		return [
			{node: 'out'}
			{
				node: 'reference'
				output:
					value: reference
					name: service['configuration']['name']
			}
		]
