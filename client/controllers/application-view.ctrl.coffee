angular.module('app-factory').controller('ApplicationViewCtrl', ['$scope', '$rootScope', 'viewSchema', ($scope, $rootScope, viewSchema) ->
	
	$scope.viewSchema = viewSchema

])
