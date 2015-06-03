angular.module('app-factory').factory 'ConfigureTableWidgetModal', ->
	return (widget) ->
		templateUrl: 'client/modals/configure-table-widget-modal.template.html'
		controller: 'ConfigureTableWidgetCtrl'
		resolve:
			'widget': -> widget

angular.module('app-factory').controller 'ConfigureTableWidgetCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'widget', ($scope, $rootScope, $modalInstance, $meteor, widget) ->

	$scope.showValidationErrors = false
	$scope.dataSourceTypes = Utils.mapToArray(ScreenWidget.DATA_SOURCE_TYPE)
	$scope.documentSchemas = $scope.$meteorCollection -> DocumentSchema.db.find('blueprint_id': $rootScope.blueprint['_id'])
	$scope.result = 
		'name': widget['name']
		'data_source': _.clone(widget['configuration']['data_source'])

	$scope.shouldShowDocumentType = -> 
		return true

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.result)
]