angular.module('app-factory').controller('FactoryLayoutCtrl', ['$scope', '$rootScope', '$meteor', '$modal', 'GenericModal', ($scope, $rootScope, $meteor, $modal, GenericModal) ->

	$scope.originalLayout = $rootScope.blueprint['layout']
	$scope.layout = $rootScope.blueprint['layout']
	$scope.editMode = false

	$scope.startEditLayout = ->
		$scope.editMode = true
		$scope.layout = angular.copy($scope.originalLayout)

	$scope.cancelEditLayout = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.layout = $scope.originalLayout

	$scope.saveLayout = ->
		$rootScope.blueprint['layout'] = $scope.layout
		$meteor.call('Blueprint.update', $rootScope.blueprint).then ->
			$scope.editMode = false
			$scope.originalLayout = $scope.layout

	$scope.addNavigationItem = ->

	$scope.editNavigationitem = (navigationItem) ->

	$scope.deleteNavigationItem = (navigationItem) ->
		return unless confirm('Are you sure you want to delete this navigation item?')
		Utils.removeFromArray($scope.layout, navigationItem)
])