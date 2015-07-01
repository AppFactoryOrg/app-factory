angular.module('app-factory').directive('afServiceRoutineConfiguration', ['$rootScope', ($rootScope) ->
	restrict: 'E'
	templateUrl: 'client/components/services/routine/service-routine-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.routines = $scope.$meteorCollection -> Routine.db.find('blueprint_id': $rootScope.blueprint['_id'], 'type': Routine.TYPE['General'].value)
])
