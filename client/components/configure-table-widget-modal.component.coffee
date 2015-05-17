angular.module('app-factory').factory 'ConfigureTableWidgetModal', ->
	return (widget) ->
		templateUrl: 'client/templates/configure-table-widget-modal.template.html'
		controller: 'ConfigureTableWidgetCtrl'
		resolve:
			'widget': -> widget

angular.module('app-factory').controller 'ConfigureTableWidgetCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'widget', ($scope, $rootScope, $modalInstance, $meteor, widget) ->

	$scope.showValidationErrors = false
	$scope.dataSourceTypes = Utils.mapToArray(ViewWidget.DATA_SOURCE_TYPE)
	$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find('blueprint_id': $rootScope.blueprint['_id'])
	$scope.result = 
		'name': widget['name']
		'data_source': _.clone(widget['configuration']['data_source'])

	$scope.shouldShowDocumentType = -> 
		return true if $scope.result['data_source']?['type'] is ViewWidget.DATA_SOURCE_TYPE['Document'].value
		return false

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		dataSourceType = _.findWhere(ViewWidget.DATA_SOURCE_TYPE, 'value': $scope.result['data_source']['type'])
		$scope.result['data_source'] = _.pick($scope.result['data_source'], dataSourceType['properties'])

		$modalInstance.close($scope.result)
]