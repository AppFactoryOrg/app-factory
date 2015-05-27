angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', ($scope) ->
	$scope.value = $scope.document['data'][$scope.attribute['id']]
	$scope.icon = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type']).icon
])