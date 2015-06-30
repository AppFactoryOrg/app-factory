@DocumentSchema =

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
		'actions'
		'primary_attribute_id'
	]

	new: ->
		'name': 					null
		'description':				null
		'attributes':				[]
		'actions':					[]
		'primary_attribute_id': 	null
		'blueprint_id': 			null

	getSortOptions: (documentSchema) ->
		options = []
		options.push({attribute: {name:'Created On'}, value: 'created_on'})
		for attribute in documentSchema['attributes']
			if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value and
				attribute['data_type'] not in [
					DocumentAttribute.DATA_TYPE['Document'].value
					DocumentAttribute.DATA_TYPE['User'].value
				]
				options.push({attribute: attribute, value: "data.#{attribute['id']}"})
		return options

	getFilterableAttributes: (documentSchema) ->
		attributes = []
		for attribute in documentSchema['attributes']
			if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
				attributes.push(attribute)
		return attributes
