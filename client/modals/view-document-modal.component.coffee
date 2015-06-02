angular.module('app-factory').factory 'ViewDocumentModal', ->
	return ({document, documentSchema, options}) ->
		templateUrl: 'client/modals/view-document-modal.template.html'
		controller: 'ViewDocumentModalCtrl'
		resolve:
			'document': -> document
			'documentSchema': -> documentSchema
			'options': -> options

angular.module('app-factory').controller('ViewDocumentModalCtrl', ['$scope', '$meteor', '$modal', '$modalInstance', 'document', 'documentSchema', 'options', 'EditDocumentModal', ($scope, $meteor, $modal, $modalInstance, document, documentSchema, options, EditDocumentModal) ->
	$scope.documentSchema = documentSchema
	$scope.document = document
	$scope.options = options
	
	$scope.editDocument = ->
		documentSchema = $scope.documentSchema
		document = $scope.document
		modal = $modal.open(new EditDocumentModal({document, documentSchema}))
		modal.result.then (document) ->
			$meteor.call('Document.update', document).then ->
				$scope.document = document

	$scope.deleteDocument = ->
		return unless confirm('Are you sure you want to delete this record? This action cannot be undone.')
		$meteor.call('Document.delete', $scope.document['_id'])
		$modalInstance.dismiss()
])