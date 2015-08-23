angular.module('app-factory').factory 'EditViewModal', ->
	return (view, documentSchema) ->
		templateUrl: 'client/modals/edit-view-modal.template.html'
		controller: 'EditViewModalCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'view': -> view
			'documentSchema': -> documentSchema

angular.module('app-factory').controller 'EditViewModalCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'view', 'documentSchema', ($scope, $rootScope, $modalInstance, $meteor, view, documentSchema) ->

	$scope.showValidationErrors = false

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.view)

	# Initialize
	if view?
		$scope.view = _.clone(view)
	else
		widget = ScreenWidget.new({type: ScreenWidget.TYPE['Table'].value})
		widget['name'] = ''
		widget['configuration']['show_name'] = false
		widget['configuration']['data_source']['type'] = ScreenWidget.DATA_SOURCE_TYPE['Database'].value
		widget['configuration']['data_source']['document_schema_id'] = documentSchema['_id']

		$scope.view =
			'widget': widget
]
