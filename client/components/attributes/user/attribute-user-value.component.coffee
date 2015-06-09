angular.module('app-factory').directive('afAttributeUserValue', ['UserUtils', (UserUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/user/attribute-user-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->

		userId = $scope.document['data'][$scope.attribute['id']]
		UserUtils.getUserName(userId)
			.then (value) ->
				$scope.value = value
			.catch ->
				$scope.value = null

])