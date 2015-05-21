angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', ($scope) ->
	$scope.value = $scope.document['data'][$scope.attribute['id']]
])