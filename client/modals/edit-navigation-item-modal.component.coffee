angular.module('app-factory').factory 'EditNavigationItemModal', ->
	return (navigationItem) ->
		templateUrl: 'client/modals/edit-navigation-item-modal.template.html'
		controller: 'EditNavigationItemCtrl'
		resolve:
			'navigationItem': -> navigationItem

angular.module('app-factory').controller 'EditNavigationItemCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', 'navigationItem', ($scope, $rootScope, $modalInstance, $meteor, navigationItem) ->

	$scope.showValidationErrors = false
	$scope.isEdit = navigationItem?
	$scope.navigationItemTypes = Utils.mapToArray(NavigationItem.TYPE)
	$scope.screens = $scope.$meteorCollection -> ScreenSchema.db.find('blueprint_id': $rootScope.blueprint['_id'])

	if navigationItem?
		$scope.result = _.clone(navigationItem)
	else
		$scope.result = NavigationItem.new({})

	$scope.shouldShowScreenSelection = -> 
		return true if $scope.result['type'] is NavigationItem.TYPE['Screen'].value
		return false

	$scope.shouldUrlInput = -> 
		return true if $scope.result['type'] is NavigationItem.TYPE['Link'].value
		return false

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.result)
]