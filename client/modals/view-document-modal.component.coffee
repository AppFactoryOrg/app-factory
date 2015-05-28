angular.module('app-factory').factory 'ViewDocumentModal', ->
	return ({document, documentSchema}) ->
		templateUrl: 'client/modals/view-document-modal.template.html'
		controller: 'ViewDocumentCtrl'
		resolve:
			'document': -> document
			'documentSchema': -> documentSchema

angular.module('app-factory').controller('ViewDocumentCtrl', ['$scope', '$meteor', '$modal', '$modalInstance', 'document', 'documentSchema', 'EditDocumentModal', ($scope, $meteor, $modal, $modalInstance, document, documentSchema, EditDocumentModal) ->
	$scope.documentSchema = documentSchema
	$scope.document = document
	
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