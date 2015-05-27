angular.module('app-factory').directive('afAttributeNumberValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		value = $scope.document['data'][$scope.attribute['id']]
		# TODO: formatting
		$scope.value = value
])