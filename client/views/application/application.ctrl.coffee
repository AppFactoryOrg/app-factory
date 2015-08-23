angular.module('app-factory').controller('ApplicationCtrl', ['$scope', '$rootScope', '$state', '$meteor', 'application', 'environment', 'blueprint', ($scope, $rootScope, $state, $meteor, application, environment, blueprint) ->

	$scope.application = $rootScope.application = application
	$scope.environment = $rootScope.environment = environment
	$scope.blueprint = $rootScope.blueprint = blueprint

	$scope.NAVIGATION_SCREEN_TYPE = NavigationItem.TYPE['Screen'].value
	$scope.NAVIGATION_LINK_TYPE = NavigationItem.TYPE['Link'].value

	document.title = $scope.application.name

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

	# Initialize
	$('body').removeClass()
	$('body').addClass('top-navigation')

	if $state.current.name is 'application'
		$state.go('application.documents')

])
