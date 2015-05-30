angular.module('app-factory').directive('afAttributeConfiguration', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/attribute-configuration.template.html'
	scope:
		'attribute': 	'='
	link: ($scope, $element) ->
		
		$scope.createConfigurationElement = ->
			name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type']).component
			childTemplate = "
				<af-attribute-#{name}-configuration
					attribute='attribute'>
				</af-attribute-#{name}-configuration>
			"
			attributeEl = $('.attribute-configuration', $element)
			attributeEl.append(childTemplate)
			$compile(attributeEl)($scope)

		$scope.clearConfigurationElement = ->
			attributeEl = $('.attribute-configuration', $element)
			attributeEl.empty()

		$scope.$watch('attribute.configuration', (newValue) ->
			if newValue?
				$scope.createConfigurationElement()
			else
				$scope.clearConfigurationElement()
		)

])