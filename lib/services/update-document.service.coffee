RoutineService.registerTemplate
	'name': 'update_document'
	'label': 'Update Document'
	'description': "Updates a document with the specified updates"
	'color': '#567CA0'
	'display_order': 50200
	'size': {height: 80, width: 150}
	'flags': ['accesses_db', 'modifies_db']
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
			name: 'reference'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.6, -1, 0]
			label: 'Reference'
			labelPosition: [2.9, 0.5]
		}
		{
			name: 'updates'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input-multiple'
			multiple: true
			position: [0, 0.8, -1, 0]
			label: 'Updates'
			labelPosition: [2.6, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Update Document service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Update Document service does not have an 'Updates' input") unless service_inputs['updates']?

		reference = service_inputs['reference']?['value']

		if reference?
			if _.isString(reference)
				document_id = reference
			else if reference.hasOwnProperty('_id')
				document_id = reference['_id']

		throw new Meteor.Error('validation', "Update Document service was given an invalid document reference.") if _.isEmpty(document_id)

		attributes = []
		service_inputs['updates'].forEach (update) ->
			update_content = update['value']
			attributes.push
				'id': update_content['attribute_id']
				'value': update_content['value']

		Meteor.call('Document.updateAttributes', {document_id, attributes})

		return [{node: 'out'}]
