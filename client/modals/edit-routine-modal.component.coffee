angular.module('app-factory').factory 'EditRoutineModal', ->
	return (routine) ->
		templateUrl: 'client/modals/edit-routine-modal.template.html'
		controller: 'EditRoutineCtrl'
		keyboard: false
		backdrop: 'static'
		windowClass: 'edit-routine-modal'
		resolve:
			'routine': -> routine

angular.module('app-factory').controller('EditRoutineCtrl', ['$scope', '$rootScope', '$modalInstance', 'routine', ($scope, $rootScope, $modalInstance, routine) ->
	
	$scope.routine = angular.copy(routine)
	$scope.services = RoutineService.registry
	$scope.newService = {}

	$scope.onServiceDrop = (event, ui) ->
		service = $scope.newService

		service['position'] = {'x': ui['position']['left'], 'y': ui['position']['top']}
		service = RoutineService.new(service)
		$scope.routine['services'].push(service)

		$scope.newService = null

	$scope.hasUnsavedChanges = ->
		return false if angular.equals(routine, $scope.routine)
		return true

	$scope.save = ->
		$meteor.call('Routine.update', $scope.routine)
			.catch (error) ->
				toaster.pop(
					type: 'error'
					body: "Could not update Routine. #{error.reason}"
					showCloseButton: true
				)

	$scope.saveAndClose = ->
		$scope.save()
			.then ->
				$modalInstance.close()

	$scope.close = ->
		return confirm('Are you sure you want to close? Unsaved changes will be lost.') if $scope.hasUnsavedChanges()
		$modalInstance.close()
])