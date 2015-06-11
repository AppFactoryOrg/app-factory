angular.module('app-factory').controller('FactoryRoutinesCtrl', ['$scope', '$rootScope', '$modal', '$meteor', 'toaster', 'GenericModal', ($scope, $rootScope, $modal, $meteor, toaster, GenericModal) ->

	$scope.routineTypes = Utils.mapToArray(Routine.TYPE)

	$scope.newRoutine = ->
		$modal.open(new GenericModal(
			title: 'New Routine'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
				{name: 'description', displayAs: 'Description', type: 'textarea'}
				{name: 'type', displayAs: 'Type', type: 'select', options: Utils.mapToArray(Routine.TYPE), required: true}
			]
		)).result.then (parameters) ->
			parameters['blueprint_id'] = $scope.environment['blueprint_id']
			$meteor.call('Routine.create', parameters)
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "Could not create Routine. #{error.reason}"
						showCloseButton: true
					)

	$scope.editRoutine = (routine) ->

	$scope.deleteRoutine = (routine) ->
		return unless confirm('Are you sure you want to delete this routine?')
		$meteor.call('Routine.delete', routine['_id'])

])