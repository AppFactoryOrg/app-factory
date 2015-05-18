angular.module('app-factory').controller('ApplicationCtrl', ['$scope', '$rootScope', '$state', 'application', 'environment', 'blueprint', ($scope, $rootScope, $state, application, environment, blueprint) ->

	$scope.application = $rootScope.application = application
	$scope.environment = $rootScope.environment = environment
	$scope.blueprint = $rootScope.blueprint = blueprint

])