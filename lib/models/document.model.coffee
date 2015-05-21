@Document =

	db: new Mongo.Collection('documents')

	new: (parameters) ->
		'data': parameters['data']
		'document_schema_id': parameters['document_schema_id']
		'environment_id': parameters['environment_id']
		'created_on': Date.now()
		'created_by': Meteor.userId()