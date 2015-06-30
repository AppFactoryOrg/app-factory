angular.module('app-factory').directive('afServiceCheckConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/services/check/service-check-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		service_template = RoutineService.getTemplate('check')
		$scope.operators = _.values(service_template['meta_data']['operators'])
])
