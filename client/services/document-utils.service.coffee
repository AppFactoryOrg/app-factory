angular.module('app-factory').factory('DocumentUtils', ['$meteor', '$q', ($meteor, $q) ->
	getById: (documentId) -> $q (resolve, reject) ->
		unless documentId?
			reject()
			return

		document = Document.db.findOne(documentId)
		if document?
			resolve(document)
		else
			console.warn('Document not found for Attribute, fetching...')
			$meteor.subscribe('Document', documentId).then ->
				document = Document.db.findOne(documentId)
				if document?
					resolve(document)
				else
					console.warn('Document not found for Attribute, even after fetching.')
					reject()
])