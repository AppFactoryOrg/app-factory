@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	ATTRIBUTE_TYPE: [
		{name: 'Text',			value: 100,		iconClass: 'fa-font'}
		{name: 'Number',		value: 200,		iconClass: 'fa-calculator'}
		{name: 'Date',			value: 300,		iconClass: 'fa-calendar-o'}
		{name: 'Currency',		value: 400,		iconClass: 'fa-dollar'}
		{name: 'Document',		value: 500,		iconClass: 'fa-file-o'}
		{name: 'Routine',		value: 600,		iconClass: 'fa-gear'}
		{name: 'User',			value: 700,		iconClass: 'fa-user'}
		{name: 'Image',			value: 800,		iconClass: 'fa-image'}
		{name: 'Coordinates',	value: 900,		iconClass: 'fa-map'}
		{name: 'Address',		value: 1000,	iconClass: 'fa-house'}
		{name: 'Phone Number',	value: 1100,	iconClass: 'fa-phone'}
		{name: 'Email',			value: 1200,	iconClass: 'fa-email'}
	]

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	new: ->
		'name': 					null
		'description':				null
		'attributes':				null
		'blueprint_id': 			null

	getNextAttributeId: (documentSchema) ->
		allIds = _.pluck(documentSchema.attributes, 'id')
		return 1 if _.isEmpty(allIds)
		highestId = _.first(allIds.sort((a,b) -> a < b))
		highestId++ 
		return highestId
