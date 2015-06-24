angular.module('app-factory').directive('afAttributeDocumentValue', ['$modal', 'ViewDocumentModal', 'DocumentUtils', ($modal, ViewDocumentModal, DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue()
			.catch ->
				$scope.value = '[ERROR]'
			.then (documentId) ->
				DocumentUtils.getPrimaryAttributeValue(documentId)
					.then (value) ->
						$scope.value = value
					.catch ->
						$scope.value = null

		$scope.viewDocument = ->
			DocumentUtils.getById($scope.document['_id'])
				.then ({document, documentSchema}) ->
					options =
						'deleteDisabled': true
						'editDisabled': true
					$modal.open(new ViewDocumentModal({document, documentSchema, options}))

])