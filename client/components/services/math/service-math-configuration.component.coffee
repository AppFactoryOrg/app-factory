angular.module('app-factory').directive('afServiceMathConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/math/service-math-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
])