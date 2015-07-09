RoutineService.registerTemplate
	'name': 'set_attribute'
	'label': 'Set Attribute'
	'description': "Sets the value of a document's attribute"
	'color': '#837a9f'
	'display_order': 800
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'document_schema_id': ''
		'attribute_id': ''
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
		document_schema_id = service['configuration']['document_schema_id']
		attribute_id = service['configuration']['attribute_id']
		return unless document_schema_id? and attribute_id?

		documentSchema = DocumentSchema.db.findOne(document_schema_id)
		return unless documentSchema?

		attribute = _.findWhere(documentSchema['attributes'], {id: attribute_id})
		return "#{attribute.name}" if attribute?

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Set Attribute service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Set Attribute service does not have a configuration") unless service['configuration']?

		input_value = service_inputs['value']?['value']

		value =
			attribute_id: service['configuration']['attribute_id']
			value: input_value ? null

		return [{
			node: 'output'
			output:
				value: value
		}]
