angular.module('app-factory').directive('afServiceCompareConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/services/compare/service-compare-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
		$scope.operators = []

		$scope.showOperators =  ->
			return false unless $scope.service?
			return false unless $scope.service['configuration']['data_type']?
			return true

		$scope.resolveOperators = ->
			operators = []
			if $scope.showOperators()
				data_type = DocumentAttribute.getDataType($scope.service['configuration']['data_type'])
				operators = _.reject(_.values(data_type['operators']), (operator) -> operator in ['between'])

			$scope.operators = operators
			$scope.service['configuration']['operator'] = null unless _.contains(operators, $scope.service['configuration']['operator'])

		# Initialize
		$scope.resolveOperators()
])
