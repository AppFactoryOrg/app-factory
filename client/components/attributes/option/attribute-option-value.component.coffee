angular.module('app-factory').directive('afAttributeOptionValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue().then (optionId) ->
			return unless optionId?

			option = _.findWhere($scope.attribute['configuration']['options'], 'id': optionId)
			return unless option?

			$scope.value = option['name']
])