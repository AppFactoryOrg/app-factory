angular.module('app-factory').controller('ViewCtrl', ['$scope', '$state', '$meteor', '$modal', 'view', 'GenericModal', ($scope, $state, $meteor, $modal, view, GenericModal) ->

	$scope.originalView = view
	$scope.view = view
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.attributeValueTypes = Utils.mapToArray(DocumentAttribute.VALUE_TYPE)
	$scope.selectedAttribute = null
	$scope.editMode = false

	$scope.startEditView = ->
		$scope.editMode = true
		$scope.view = angular.copy($scope.originalView)

	$scope.cancelEditView = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.view = $scope.originalView

	$scope.saveView = ->
		view = angular.copy($scope.view)
		$meteor.call('View.update', view).then ->
			$scope.editMode = false
			$scope.originalView = view

	$scope.deleteView = ->
		return unless confirm('Are you sure you want to delete this view?')
		$meteor.call('View.delete', $scope.view['_id']).then ->
			$state.go('factory.dashboard')

])