angular.module('app-factory').directive('afAttributeUserInput', ['$modal', 'SelectUserModal', 'UserUtils', ($modal, SelectUserModal, UserUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/user/attribute-user-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='	
	link: ($scope) ->

		$scope.userDisplayName = ''

		$scope.hasValue = ->
			return $scope.object[$scope.key]?

		$scope.lookupUser = ->
			$modal.open(new SelectUserModal()).result.then (user) ->
				$scope.object[$scope.key] = user['_id']
				$scope.loadUser()

		$scope.clearUser = ->
			$scope.object[$scope.key] = null
			$scope.loadUser()

		$scope.loadUser = ->
			userId = $scope.object[$scope.key]
			UserUtils.getUserName(userId)
				.then (value) ->
					$scope.userDisplayName = value
				.catch ->
					$scope.userDisplayName = null

		# Initialize
		$scope.loadUser()
])