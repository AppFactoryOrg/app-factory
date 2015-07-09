angular.module('app-factory').directive('afServiceGetOutputConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/services/get-output/service-get-output-configuration.template.html'
	scope:
		'service': 	'='
])
