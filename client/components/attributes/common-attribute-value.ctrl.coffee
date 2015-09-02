angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', ($scope) ->

	if $scope.attribute['data_key']?
		$scope.$watch 'document[attribute.data_key]', (value) ->
			$scope.$broadcast('ATTRIBUTE_VALUE', value)
	else
		$scope.$watch 'document.data[attribute.id]', (value) ->
			$scope.$broadcast('ATTRIBUTE_VALUE', value)
])
