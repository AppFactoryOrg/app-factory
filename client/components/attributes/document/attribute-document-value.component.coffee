angular.module('app-factory').directive('afAttributeDocumentValue', ['$modal', 'ViewDocumentModal', 'DocumentUtils', ($modal, ViewDocumentModal, DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.$on 'ATTRIBUTE_VALUE', (e, documentId) ->
			$scope.value = documentId
			if documentId?
				DocumentUtils.getPrimaryAttributeValue(documentId)
					.then (value) ->
						$scope.displayValue = value
					.catch ->
						$scope.displayValue = null
			else
				$scope.displayValue = null

		$scope.viewDocument = ->
			DocumentUtils.getById($scope.value)
				.then ({document, documentSchema}) ->
					options =
						'deleteDisabled': true
						'editDisabled': true
					$modal.open(new ViewDocumentModal({document, documentSchema, options}))

])
