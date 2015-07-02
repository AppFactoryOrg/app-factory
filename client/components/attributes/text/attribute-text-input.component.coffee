angular.module('app-factory').directive('afAttributeTextInput', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/text/attribute-text-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='
	link: ($scope) ->
		$scope.textUpdated = ->
			if $scope.object[$scope.key] is ''
				$scope.object[$scope.key] = null
])
