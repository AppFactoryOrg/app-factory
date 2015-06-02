angular.module('app-factory').directive('afAttributeDocumentValue', ['DocumentUtils', (DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		
		documentId = $scope.document['data'][$scope.attribute['id']]
		DocumentUtils.getById(documentId)
			.then (document) ->
				documentSchema = DocumentSchema.db.findOne(document['document_schema_id'])
				attributeId = documentSchema['attributes'][0]['id']
				$scope.value = document['data'][attributeId]
			.catch ->
				$scope.value = null
])