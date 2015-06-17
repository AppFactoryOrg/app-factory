RoutineService.registerTemplate
	'name': 'update_document'
	'label': 'Update Document'
	'description': "Updates a document with the specified updates"
	'color': '#567CA0'
	'display_order': 50000
	'size': {height: 80, width: 150}
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
			name: 'document'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.6, -1, 0]
			label: 'Document'
			labelPosition: [2.9, 0.55]
		}
		{
			name: 'updates'
			type: RoutineService.NODE_TYPE['Input'].value
			multiple: true
			position: [0, 0.8, -1, 0]
			label: 'Updates'
			labelPosition: [2.5, 0.55]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Update Document service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Update Document service does not have a 'document' input") unless service.inputs.hasOwnProperty('document')
		throw new Meteor.Error('validation', "Update Document service does not have a 'updates' input") unless service.inputs.hasOwnProperty('updates')
		
		document = service.inputs['document']
		
		updates = service.inputs['updates']
		updates.forEach (update) ->
			document['data'][update['attribute_id']] = update['value']

		Meteor.call('Document.update', document)
		
		return [{node: 'out'}]