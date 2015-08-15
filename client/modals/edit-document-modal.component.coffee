angular.module('app-factory').factory 'EditDocumentModal', ->
	return ({document, documentSchema}) ->
		templateUrl: 'client/modals/edit-document-modal.template.html'
		controller: 'EditDocumentCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'document': -> document
			'documentSchema': -> documentSchema

angular.module('app-factory').controller('EditDocumentCtrl', ['$scope', '$rootScope', '$modalInstance', 'toaster', 'document', 'documentSchema', ($scope, $rootScope, $modalInstance, toaster, document, documentSchema) ->
	$scope.documentSchema = documentSchema

	if document?
		$scope.document = angular.copy(document)
	else
		$scope.createMode = true
		$scope.document =
			'document_schema_id': documentSchema['_id']
			'environment_id': $rootScope.environment['_id']
			'data': {}

	$scope.submit = ->
		try
			Document.validate($scope.document, $scope.documentSchema)
			$modalInstance.close($scope.document)
		catch error
			message = if error.reason? then error.reason else error.message
			toaster.pop(
				type: 'error'
				body: "#{message}"
				showCloseButton: true
			)
])
