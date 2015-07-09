RoutineService.registerTemplate
	'name': 'delete_document'
	'label': 'Delete Document'
	'description': "Deletes the given document."
	'color': '#567CA0'
	'display_order': 50300
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
			position: [0, 0.75, -1, 0]
			label: 'Reference'
			labelPosition: [2.9, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Delete Document service does not have any inputs") unless service_inputs?

		reference = service_inputs['reference']?['value']

		if reference?
			if _.isString(reference)
				document_id = reference
			else if reference.hasOwnProperty('_id')
				document_id = reference['_id']

		throw new Meteor.Error('validation', "Delete Document service was given an invalid document reference.") if _.isEmpty(document_id)

		Meteor.call('Document.delete', document_id)

		return [{node: 'out'}]
