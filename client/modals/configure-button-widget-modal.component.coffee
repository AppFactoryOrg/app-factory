angular.module('app-factory').factory 'ConfigureButtonWidgetModal', ->
	return (widget) ->
		templateUrl: 'client/modals/configure-button-widget-modal.template.html'
		controller: 'ConfigureButtonWidgetCtrl'
		resolve:
			'widget': -> widget

angular.module('app-factory').controller 'ConfigureButtonWidgetCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'widget', ($scope, $rootScope, $modalInstance, $meteor, widget) ->

	$scope.showValidationErrors = false
	$scope.routines = $scope.$meteorCollection -> Routine.db.find('blueprint_id': $rootScope.blueprint['_id'], 'type': Routine.TYPE['General'].value)
	$scope.result = 
		'name': widget['name']
		'routine_id': _.clone(widget['configuration']['routine_id'])

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.result)
]