@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
		'primary_attribute_id'
	]

	new: ->
		'name': 					null
		'description':				null
		'attributes':				[]
		'primary_attribute_id': 	null
		'blueprint_id': 			null

	getSortOptions: (documentSchema) ->
		options = []
		options.push({attribute: {name:'Created On'}, value: 'created_on'})
		for attribute in documentSchema['attributes']
			options.push({attribute: attribute, value: "data.#{attribute['id']}"})
		return options

	getFilterableAttributes: (documentSchema) ->
		attributes = []
		for attribute in documentSchema['attributes']
			attributes.push(attribute)
		return attributes