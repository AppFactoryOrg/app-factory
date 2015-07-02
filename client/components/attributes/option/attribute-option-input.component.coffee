angular.module('app-factory').directive('afAttributeOptionInput', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='	
	link: ($scope) ->
		$scope.options = _.filter($scope.config['options'], 'active': true)		
])