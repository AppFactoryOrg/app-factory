angular.module('app-factory').directive('afServiceVariableConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/variable/service-variable-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
])