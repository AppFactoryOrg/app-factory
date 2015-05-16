angular.module('app-factory').factory 'ConfigureTableWidgetModal', ->
	return (widget) ->
		templateUrl: 'client/templates/configure-table-widget-modal.template.html'
		controller: 'ConfigureTableWidgetCtrl'
		resolve:
			'widget': -> widget

angular.module('app-factory').controller 'ConfigureTableWidgetCtrl', ($scope, $modalInstance, widget) ->

	$scope.showValidationErrors = false
	$scope.dataSourceTypes = Utils.mapToArray(ViewWidget.DATA_SOURCE_TYPE)
	$scope.result = 
		'name': widget['name']
		'data_source': _.clone(widget['configuration']['data_source'])

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false
			
		$modalInstance.close($scope.result)