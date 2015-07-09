RoutineService.registerTemplate
	'name': 'get_attribute'
	'label': 'Get Attribute'
	'description': "Gets the value of a document's attribute"
	'color': '#837a9f'
	'display_order': 700
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'document_schema_id': null
		'attribute_id': null
	'flags': []
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
		document_schema_id = service['configuration']['document_schema_id']
		attribute_id = service['configuration']['attribute_id']
		return unless document_schema_id? and attribute_id?

		documentSchema = DocumentSchema.db.findOne(document_schema_id)
		return unless documentSchema?

		attribute = _.findWhere(documentSchema['attributes'], {id: attribute_id})
		return "#{attribute.name}" if attribute?

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Get Attribute service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Get Attribute service does not have a configuration") unless service['configuration']?

		document = service_inputs['document']?['value']

		if document?
			attribute_id = service['configuration']['attribute_id']
			value = document?['data'][attribute_id]

		value = value ? null

		return [{
			node: 'output'
			output:
				value: value
				name: service['configuration']['name']
		}]
