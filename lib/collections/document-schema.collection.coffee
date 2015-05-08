@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	ATTRIBUTE_DATA_TYPES: [
		{name: 'Text',			value: 100,		iconClass: 'fa-font'}
		{name: 'Number',		value: 150,		iconClass: 'fa-calculator'}
		{name: 'Date',			value: 200,		iconClass: 'fa-calendar'}
		{name: 'Currency',		value: 250,		iconClass: 'fa-dollar'}
		{name: 'Document',		value: 300,		iconClass: 'fa-file-o'}
		{name: 'User',			value: 350,		iconClass: 'fa-user'}
		{name: 'Image',			value: 400,		iconClass: 'fa-image'}
		{name: 'Coordinates',	value: 450,		iconClass: 'fa-map'}
		{name: 'Address',		value: 500,	    iconClass: 'fa-home'}
		{name: 'Phone Number',	value: 550,		iconClass: 'fa-phone'}
		{name: 'Email',			value: 600,		iconClass: 'fa-at'}
	]

	ATTRIBUTE_VALUE_TYPE: [
		{name: 'Input',			value: 100,		iconClass: 'fa-edit'}
		{name: 'Fixed',			value: 150,		iconClass: 'fa-wrench'}
		{name: 'Routine',		value: 200,		iconClass: 'fa-gear'}
	]

	new: ->
		'name': 					null
		'description':				null
		'attributes':				null
		'blueprint_id': 			null

	newAttribute: ->
		'name':						null
		'value_type':				null
		'input_type':				null

	getNextAttributeId: (documentSchema) ->
		allIds = _.pluck(documentSchema.attributes, 'id')
		return 1 if _.isEmpty(allIds)
		highestId = _.first(allIds.sort((a,b) -> a < b))
		highestId++ 
		return highestId
