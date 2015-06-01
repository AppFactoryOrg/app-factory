angular.module('app-factory').directive('afAttributeOptionValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		optionId = $scope.document['data'][$scope.attribute['id']]
		return unless optionId?

		option = _.findWhere($scope.attribute['configuration']['options'], 'id': optionId)
		return unless option?

		$scope.value = option['name']
])