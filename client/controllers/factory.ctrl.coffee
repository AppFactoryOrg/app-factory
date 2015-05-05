angular.module('app-factory').controller('FactoryCtrl', ['$scope', '$state', '$meteor', 'application', ($scope, $state, $meteor, application) ->
	$scope.application = application
])