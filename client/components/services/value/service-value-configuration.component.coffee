angular.module('app-factory').directive('afServiceValueConfiguration', ['$compile', '$meteor', '$timeout', ($compile, $meteor, $timeout) ->
	restrict: 'E'
	templateUrl: 'client/components/services/value/service-value-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = _.reject(Utils.mapToArray(DocumentAttribute.DATA_TYPE), (type) -> type['configuration']?)
		$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find()

		$scope.showValue =  ->
			return false unless $scope.service?
			return false unless $scope.service['configuration']['data_type']?
			return true

		$scope.setupValueInput = -> $timeout ->
			if $scope.showValue()
				type = $scope.service['configuration']['data_type']
				name = _.findWhere(DocumentAttribute.DATA_TYPE, value: type).component
				childTemplate = "
					<af-attribute-#{name}-input 
						key='\"value\"'
						object='service.configuration'
						name='service.configuration.name'
						config='service.configuration'>
					</af-attribute-#{name}-input >
				"
				attributesEl = $('.service-value', $element)
				attributesEl.empty()
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)
			else
				$('.service-value', $element).empty()

		# Initialize
		$scope.setupValueInput()

		$scope.$watch 'service.configuration', (newConfig, oldConfig) ->
			return unless newConfig? and oldConfig?

			if newConfig['data_type'] isnt oldConfig['data_type']
				newConfig['value'] = null
				$scope.setupValueInput()
		, true
])