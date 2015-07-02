angular.module('app-factory').factory 'EditActionModal', ->
	return (action) ->
		templateUrl: 'client/modals/edit-action-modal.template.html'
		controller: 'EditActionModalCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'action': -> action

angular.module('app-factory').controller 'EditActionModalCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'action', ($scope, $rootScope, $modalInstance, $meteor, action) ->

	$scope.showValidationErrors = false
	$scope.routines = $scope.$meteorCollection -> Routine.db.find('blueprint_id': $rootScope.blueprint['_id'], 'type': Routine.TYPE['Action'].value)

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.action)

	# Initialize
	if action?
		$scope.action = _.clone(action)
	else
		$scope.action =
			'name': null
			'routine_id': null
]