angular.module('app-factory').controller('ApplicationScreenCtrl', ['$scope', '$rootScope', 'screenSchema', ($scope, $rootScope, screenSchema) ->
	
	$scope.screenSchema = screenSchema

])
