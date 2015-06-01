angular.module('app-factory').directive('afAttributeDocumentInput', ['$modal', 'SelectDocumentModal', ($modal, SelectDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->

		$scope.getDocumentDisplayName = ->
			return $scope.document.data[$scope.attribute['id']]

		$scope.hasValue = ->
			return $scope.document.data[$scope.attribute['id']]?

		$scope.lookupDocument = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
				$scope.document.data[$scope.attribute['id']] = document['_id']

		$scope.clearDocument = ->
			$scope.document.data[$scope.attribute['id']] = null
])