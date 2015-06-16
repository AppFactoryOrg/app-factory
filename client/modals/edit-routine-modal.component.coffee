angular.module('app-factory').factory 'EditRoutineModal', ->
	return (routine) ->
		templateUrl: 'client/modals/edit-routine-modal.template.html'
		controller: 'EditRoutineCtrl'
		keyboard: false
		backdrop: 'static'
		windowClass: 'edit-routine-modal'
		resolve:
			'routine': -> routine

angular.module('app-factory').controller('EditRoutineCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'routine', 'toaster', ($scope, $rootScope, $modalInstance, $meteor, routine, toaster) ->
	
	DELETE_KEY = 8

	$scope.routine = angular.copy(routine)
	$scope.routine.services.forEach (service) ->
		service['$template'] = _.findWhere(RoutineService.service_templates, 'name': service['name'])

	$scope.serviceTemplates = _.clone(RoutineService.service_templates)
	$scope.newService = {}
	$scope.selectedService = null

	$scope.onServiceDrop = (event, ui) ->
		service = RoutineService.new($scope.newService)
		service['position'] =
			'x': event['pageX'] - $(event['target']).offset().left - 20
			'y': event['pageY'] - $(event['target']).offset().top - 20
		$scope.addService(service)

		$scope.newService = null

	$scope.serviceIsConfigurable = (service) ->
		return service['$template']['configuration']?

	$scope.serviceIsSelected = (service) ->
		return service is $scope.selectedService

	$scope.serviceClicked = (service, event) ->
		event.stopPropagation()
		$scope.selectedService = service

	$scope.canvasClicked = (event) ->
		event.stopPropagation()
		$scope.selectedService = null

	$scope.$on 'KEYDOWN', (e, event) ->
		if event['which'] is DELETE_KEY and $scope.selectedService?
			$scope.deleteService($scope.selectedService)
			$scope.selectedService = null

	$scope.configureService = (service) ->
		event.stopPropagation()
		$scope.selectedService = service
		# TODO

	$scope.addService = (service) ->
		service['$template'] = _.findWhere(RoutineService.service_templates, 'name': service['name'])
		$scope.routine['services'].push(service)

	$scope.deleteService = (service) ->
		return unless confirm('Are you sure you want to delete this service?')
		Utils.removeFromArray(service, $scope.routine.services)

	$scope.hasUnsavedChanges = ->
		return false if angular.equals(routine, $scope.routine)
		return true

	$scope.save = ->
		routine = angular.copy($scope.routine)
		routine.services.forEach (service) -> delete service['$template']

		$meteor.call('Routine.update', routine)
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
		return unless confirm('Are you sure you want to close? Unsaved changes will be lost.') if $scope.hasUnsavedChanges()
		$modalInstance.dismiss()
])