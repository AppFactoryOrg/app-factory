@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	new: ->
		'name': 			null
		'description':		null
		'attributes':		[]
		'blueprint_id': 	null

	getSortableAttributes: (documentSchema) ->
		attributes = []
		attributes.push({name: 'Created On', value: 'created_on'})
		for attribute in documentSchema.attributes
			attributes.push({name: attribute['name'], value: "data.#{attribute['id']}"})
		return attributes