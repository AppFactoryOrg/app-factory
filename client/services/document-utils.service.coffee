angular.module('app-factory').factory('DocumentUtils', ['$meteor', '$q', ($meteor, $q) ->
	getById: (documentId) -> $q (resolve, reject) ->
		unless documentId?
			reject()
			return

		document = Document.db.findOne(documentId)
		if document?
			documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
			resolve({document, documentSchema})
		else
			console.warn('Document not found for Attribute, fetching...')
			$meteor.subscribe('Document', documentId).then ->
				document = Document.db.findOne(documentId)
				if document?
					documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
					resolve({document, documentSchema})
				else
					console.warn('Document not found for Attribute, even after fetching.')
					reject()

	getPrimaryAttributeValue: (documentId) -> $q (resolve, reject) =>
		@getById(documentId)
			.then ({document}) ->
				documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
				attribute = _.find(documentSchema['attributes'], {'id': documentSchema['primary_attribute_id']})
				reject() unless attribute?
				resolve(document['data'][attribute['id']])
			.catch ->
				reject()
])