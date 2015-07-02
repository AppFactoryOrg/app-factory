angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', '$q', '$meteor', ($scope, $q, $meteor) ->
	
	$scope.getValue = -> $q (resolve, reject) ->
		value = $scope.document['data'][$scope.attribute['id']]
		resolve(value)
])