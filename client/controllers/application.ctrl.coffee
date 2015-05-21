angular.module('app-factory').controller('ApplicationCtrl', ['$scope', '$rootScope', '$state', 'application', 'environment', 'blueprint', ($scope, $rootScope, $state, application, environment, blueprint) ->

	$scope.application = $rootScope.application = application
	$scope.environment = $rootScope.environment = environment
	$scope.blueprint = $rootScope.blueprint = blueprint

	$scope.NAVIGATION_VIEW_TYPE = NavigationItem.TYPE['View'].value
	$scope.NAVIGATION_LINK_TYPE = NavigationItem.TYPE['Link'].value

	document.title = $scope.application.name

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

	# Initialize
	$('body').removeClass()
	$('body').addClass('top-navigation')

	if $state.current.name is 'application'
		view_schema_id = blueprint['layout']['home_view_schema_id']
		if view_schema_id?
			$state.go("application.view", {view_schema_id})

])