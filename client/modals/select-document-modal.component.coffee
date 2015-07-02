angular.module('app-factory').factory 'SelectDocumentModal', ->
	return (documentSchema) ->
		templateUrl: 'client/modals/select-document-modal.template.html'
		controller: 'SelectDocumentModalCtrl'
		size: 'lg'
		resolve:
			'documentSchema': -> documentSchema

angular.module('app-factory').controller('SelectDocumentModalCtrl', ['$scope', '$modalInstance', 'documentSchema', ($scope, $modalInstance, documentSchema) ->
	$scope.widget = ScreenWidget.new({type: ScreenWidget.TYPE['Table'].value})
	$scope.widget['name'] = "Select #{documentSchema.name}"
	$scope.widget['configuration']['data_source']['type'] = ScreenWidget.DATA_SOURCE_TYPE['Database'].value
	$scope.widget['configuration']['data_source']['document_schema_id'] = documentSchema['_id']
	$scope.widget['configuration']['show_edit_buttons'] = false
	$scope.widget['configuration']['show_select_button'] = true

	$scope.$on('DOCUMENT_SELECTED', (event, document) ->
		$modalInstance.close(document)
		event.stopPropagation()
	)

])