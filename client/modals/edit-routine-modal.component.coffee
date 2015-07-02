angular.module('app-factory').factory 'EditRoutineModal', ->
	return (routine) ->
		templateUrl: 'client/modals/edit-routine-modal.template.html'
		controller: 'EditRoutineCtrl'
		keyboard: false
		backdrop: 'static'
		windowClass: 'edit-routine-modal'
		resolve:
			'routine': -> routine

angular.module('app-factory').controller('EditRoutineCtrl', ['$scope', '$rootScope', '$timeout', '$modalInstance', '$meteor', 'routine', 'toaster', 'RoutineUtils', ($scope, $rootScope, $timeout, $modalInstance, $meteor, routine, toaster, RoutineUtils) ->

	DELETE_KEY = 8

	$scope.routine = angular.copy(routine)
	$scope.routine.services.forEach (service) ->
		service['$template'] = _.findWhere(RoutineService.service_templates, 'name': service['name'])

	$scope.serviceTemplates = _.sortBy(_.clone(RoutineService.getServicesTemplatesForRoutine($scope.routine)), 'display_order')
	$scope.newService = {}
	$scope.selectedService = null
	$scope.canvas = null
	$scope.configuringService = null

	# == Modal Controls ===================================================

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


	# == Canvas Helpers ===================================================

	$scope.onServiceDrop = (event, ui) ->
		service = RoutineService.new($scope.newService)
		service['position'] =
			'x': event['pageX'] - $(event['target']).offset().left - 20
			'y': event['pageY'] - $(event['target']).offset().top - 20
		$scope.addService(service)

		$scope.newService = null

	$scope.serviceClicked = (service, event) ->
		event.stopPropagation()
		$scope.configuringService = null unless service is $scope.configuringService
		$scope.selectedService = service

	$scope.canvasClicked = (event) ->
		event.stopPropagation()
		$scope.selectedService = null
		$scope.configuringService = null

	$scope.onKeyDown = ->
		activeTagName = document.activeElement?.tagName?.toLowerCase()
		if event['which'] is DELETE_KEY and $scope.selectedService? and activeTagName not in ['input', 'textarea', 'select']
			$scope.deleteService($scope.selectedService)
			$scope.selectedService = null

	$(document).on('keydown', $scope.onKeyDown)
	$scope.$on '$destroy', -> $(document).off('keydown', $scope.onKeyDown)

	# == Service Helpers ===================================================

	$scope.serviceIsConfigurable = (service) ->
		return service['$template']['configuration']?

	$scope.serviceIsSelected = (service) ->
		return service is $scope.selectedService

	$scope.getServiceSubtitle = (service) ->
		return service['$template'].describeConfiguration?(service)

	$scope.addService = (service) ->
		service['$template'] = _.findWhere(RoutineService.service_templates, 'name': service['name'])
		$scope.routine['services'].push(service)
		$timeout -> $scope.setupService(service)

	$scope.deleteService = (service) ->
		return unless confirm('Are you sure you want to delete this service?')
		Utils.removeFromArray(service, $scope.routine.services)
		service['$template']['nodes'].forEach (node) ->
			$scope.canvas.deleteEndpoint("#{service.id}_#{node.name}")

	$scope.configureService = (service) ->
		event.stopPropagation()
		$scope.selectedService = service
		$scope.configuringService = service

	$scope.setupService = (service) ->
		serviceElement = document.getElementById(service['id'])
		serviceElement.style.left = service['position']['x']
		serviceElement.style.top = service['position']['y']

		$scope.canvas.draggable(serviceElement, {
			containment: 'routine-canvas'
			stop: (event) ->
				id = event['el']['id']
				service = _.findWhere($scope.routine['services'], {id})
				service['position']['x'] = event['pos'][0]
				service['position']['y'] = event['pos'][1]
		})

		service['$template']['nodes'].forEach (node) ->
			endpointStyle = RoutineUtils.getEndpointStyleForNode(node)

			additionalStyles = {
				anchor: node['position']
				uuid: "#{service.id}_#{node.name}"
			}

			if node['label']?
				additionalStyles['overlays'] = [
					[ "Label", {
						id: "#{service.id}_#{node.name}_label"
						label: node['label']
						location: node['labelPosition']
						cssClass: 'service-node-label'
					}]
				]

			$scope.canvas.addEndpoint(service['id'], endpointStyle, additionalStyles)

	$scope.setupConnection = (connection) ->
		$scope.canvas.connect({uuids: [connection['fromNode'], connection['toNode']], editable: true})

	# == Setup ===================================================

	$scope.refreshConnections = ->
		$scope.routine['connections'] = []
		connections = $scope.canvas.getConnections()
		connections.forEach (connection) ->
			ids = connection.getUuids()
			$scope.routine['connections'].push(
				'fromNode': ids[0]
				'toNode': ids[1]
			)

	$scope.buildCanvas = ->
		jsPlumb.ready ->
			$scope.canvas = jsPlumb.getInstance(
				Container: 'routine-canvas'
			)

			$scope.routine['services'].forEach (service) -> $scope.setupService(service)
			$scope.routine['connections'].forEach (connection) -> $scope.setupConnection(connection)

			$scope.canvas.bind 'connection', -> $scope.$apply -> $scope.refreshConnections()
			$scope.canvas.bind 'connectionDetached', -> $scope.$apply ->$scope.refreshConnections()
			$scope.canvas.bind 'connectionMoved', -> $scope.$apply ->$scope.refreshConnections()

	# Initialize
	$timeout -> $scope.buildCanvas()
])
