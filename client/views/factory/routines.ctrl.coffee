angular.module('app-factory').controller('FactoryRoutinesCtrl', ['$scope', '$rootScope', '$modal', '$meteor', 'toaster', 'GenericModal', 'EditRoutineModal', ($scope, $rootScope, $modal, $meteor, toaster, GenericModal, EditRoutineModal) ->

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
		$modal.open(new GenericModal(
			title: 'Edit Routine'
			submitAction: 'Save'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true, default: routine['name']}
				{name: 'description', displayAs: 'Description', type: 'textarea', default: routine['description']}
				{name: 'type', displayAs: 'Type', type: 'select', options: Utils.mapToArray(Routine.TYPE), required: true, default: routine['type']}
			]
		)).result.then (parameters) ->
			updated_routine = _.clone(routine)
			_.assign(updated_routine, parameters)
			$meteor.call('Routine.update', updated_routine)
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "Could not update Routine. #{error.reason}"
						showCloseButton: true
					)

	$scope.configureRoutine = (routine) ->
		$modal.open(new EditRoutineModal(routine))

	$scope.deleteRoutine = (routine) ->
		return unless confirm('Are you sure you want to delete this routine?')
		$meteor.call('Routine.delete', routine['_id'])

	#DEBUG
	# $scope.editRoutine($scope.routines[0])

])
