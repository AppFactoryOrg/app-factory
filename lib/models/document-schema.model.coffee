@DocumentSchema =

	db: new Mongo.Collection('document-schema',
		transform: (document_schema) ->
			document_schema.views?.forEach (view) ->
				if _.isString(view['filter'])
					try view['filter'] = JSON.parse(view['filter'])
					try view['sort'] = JSON.parse(view['sort'])
					try view['limits'] = JSON.parse(view['limits'])

			return document_schema
	)

	MUTABLE_PROPERTIES: [
		'name'
		'abbreviation'
		'description'
		'attributes'
		'actions'
		'views'
		'primary_attribute_id'
	]

	new: ->
		'name': 					null
		'abbreviation':				null
		'description':				null
		'attributes':				[]
		'actions':					[]
		'views':					[]
		'primary_attribute_id': 	null
		'blueprint_id': 			null

	getSortOptions: (documentSchema) ->
		options = []

		attributes = DocumentSchema.getAllAttributes(documentSchema)

		for attribute in attributes
			options.push
				'attribute': attribute
				'value': DocumentAttribute.getDataKey(attribute)

		return options

	getAllAttributes: (documentSchema) ->
		attributes = []

		for attribute in documentSchema['attributes']
			if attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Input'].value
				attributes.push(attribute)

		attributes.push(DocumentAttribute.getCreatedByAsAttribute())
		attributes.push(DocumentAttribute.getCreatedOnAsAttribute())

		return attributes
