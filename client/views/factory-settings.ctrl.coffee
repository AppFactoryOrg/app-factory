angular.module('app-factory').controller('FactorySettingsCtrl', ['$scope', '$rootScope', '$meteor', '$modal', 'EditNavigationItemModal', ($scope, $rootScope, $meteor, $modal, EditNavigationItemModal) ->

	$scope.originalApplication = $rootScope.application
	$scope.application = angular.copy($scope.originalApplication)
	$scope.editMode = false
	$scope.showValidationErrors = false

	$scope.startEditSettings = ->
		$scope.editMode = true
		$scope.application = angular.copy($scope.originalApplication)

	$scope.cancelEditSettings = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.application = angular.copy($scope.originalApplication)

	$scope.saveSettings = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$meteor.call('Application.update', $scope.application).then ->
			$scope.editMode = false
			$scope.originalApplication = $scope.application

])