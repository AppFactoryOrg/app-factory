@Document =

	db: new Mongo.Collection('documents',
		transform: (document) ->
			return document if Meteor.isClient

			document_schema = DocumentSchema.db.findOne(document['document_schema_id'])
			throw new Meteor.Error('data', 'Cannot find Document Schema') unless document_schema?

			environment_id = document['environment_id']

			routine_attributes = _.filter(document_schema['attributes'], {'value_type': DocumentAttribute.VALUE_TYPE['Routine'].value})
			routine_attributes.forEach (attribute) ->
				routine_id = attribute['routine_id']
				return unless routine_id?

				routine = Routine.db.findOne(routine_id)
				return unless routine?
				throw new Meteor.Error('validation', "Routine is not of the 'Attribute' type") unless routine['type'] is Routine.TYPE['Attribute'].value

				inputs = [{
					name: 'Document'
					value: document
				}]

				try
					outputs = Routine.execute(routine, inputs, environment_id)
				catch error
					console.log("Routine attribute encountered an error: #{error.stack}")

				value = null
				if outputs?.length > 0
					value = outputs[0]['value']

				document['data'][attribute['id']] = value

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
