angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', ($scope) ->

	$scope.$watch 'document.data[attribute.id]', (value) ->
		$scope.$broadcast('ATTRIBUTE_VALUE', value)
])
