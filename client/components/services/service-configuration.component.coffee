angular.module('app-factory').directive('afServiceConfiguration', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/components/services/service-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		
		$scope.createConfigurationElement = ->
			name = $scope.service['name']
			childTemplate = "
				<af-service-#{name}-configuration
					service='service'>
				</af-service-#{name}-configurationtion>
			"
			attributeEl = $('.service-configuration', $element)
			attributeEl.append(childTemplate)
			$compile(attributeEl)($scope)

		$scope.clearConfigurationElement = ->
			attributeEl = $('.service-configuration', $element)
			attributeEl.empty()

		$scope.$watch('service', (newValue) ->
			if newValue?
				$scope.createConfigurationElement()
			else
				$scope.clearConfigurationElement()
		)

])