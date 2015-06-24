@Document =

	db: new Mongo.Collection('documents',
		transform: (document) ->
			return document if Meteor.isClient
			document_id = document['_id']

			document_schema = DocumentSchema.db.findOne(document['document_schema_id'])
			throw new Meteor.Error('data', 'Cannot find Document Schema') unless document_schema?

			routine_attributes = _.filter(document_schema['attributes'], {'value_type': DocumentAttribute.VALUE_TYPE['Routine'].value})
			routine_attributes.forEach (attribute) ->
				routine_id = attribute['routine_id']
				inputs = [{
					name: 'Document'
					value: document
				}]

				outputs = Meteor.call('Routine.execute', {routine_id, inputs})

				if outputs.length > 0
					value = outputs[0]['value']
				else 
					value = null

				attribute_id = attribute['id']
				document['data'][attribute_id] = value

			return document
	)

	MUTABLE_PROPERTIES: [
		'data'
	]

	new: (parameters) ->
		'data': parameters['data']
		'document_schema_id': parameters['document_schema_id']
		'environment_id': parameters['environment_id']
		'created_on': Date.now()
		'created_by': Meteor.userId()