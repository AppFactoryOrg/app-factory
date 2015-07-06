angular.module('app-factory').directive('afAttributeOptionValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.$on 'ATTRIBUTE_VALUE', (e, optionId) ->
			option = _.findWhere($scope.attribute['configuration']['options'], 'id': optionId)
			if option?
				$scope.value = option['name']
			else
				$scope.value = null
])
