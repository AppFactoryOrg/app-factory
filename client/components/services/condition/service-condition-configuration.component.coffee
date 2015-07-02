angular.module('app-factory').directive('afServiceConditionConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/services/condition/service-condition-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		service_template = RoutineService.getTemplate('condition')
		$scope.operators = _.values(service_template['meta_data']['operators'])
])
