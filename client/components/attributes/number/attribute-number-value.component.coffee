angular.module('app-factory').directive('afAttributeNumberValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue().then (value) ->
			$scope.value = value
])