angular.module('app-factory').directive('afAttributeDocumentValue', ['DocumentUtils', (DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		
		documentId = $scope.document['data'][$scope.attribute['id']]
		DocumentUtils.getPrimaryAttributeValue(documentId)
			.then (value) ->
				$scope.value = value
			.catch ->
				$scope.value = null
])