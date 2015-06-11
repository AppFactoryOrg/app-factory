angular.module('app-factory').directive('afAttributeUserValue', ['UserUtils', (UserUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/user/attribute-user-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue().then (userId) ->
			UserUtils.getUserName(userId)
				.then (value) ->
					$scope.value = value
				.catch ->
					$scope.value = null
])