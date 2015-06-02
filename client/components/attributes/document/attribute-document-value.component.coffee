angular.module('app-factory').directive('afAttributeDocumentValue', ['$meteor', ($meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		
		fillDocument = (document) ->
			documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
			attributeId = documentSchema['attributes'][0]['id']
			$scope.value = document['data'][attributeId]

		documentId = $scope.document['data'][$scope.attribute['id']]
		return unless documentId?

		document = Document.db.findOne(documentId)
		if document?
			fillDocument(document)
		else
			console.warn('Document not found for Attribute, fetching...')
			$meteor.subscribe('Document', documentId).then ->
				document = Document.db.findOne(documentId)
				if document?
					fillDocument(document)
				else
					console.warn('Document not found for Attribute, even after fetching.')
])