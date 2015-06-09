angular.module('app-factory').directive('afAttributeUserInput', ['$modal', 'SelectUserModal', 'UserUtils', ($modal, SelectUserModal, UserUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/user/attribute-user-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->

		$scope.userDisplayName = ''

		$scope.hasValue = ->
			return $scope.document.data[$scope.attribute['id']]?

		$scope.lookupUser = ->
			$modal.open(new SelectUserModal()).result.then (user) ->
				$scope.document.data[$scope.attribute['id']] = user['_id']
				$scope.loadUser()

		$scope.clearUser = ->
			$scope.document.data[$scope.attribute['id']] = null
			$scope.loadUser()

		$scope.loadUser = ->
			userId = $scope.document['data'][$scope.attribute['id']]
			UserUtils.getUserName(userId)
				.then (value) ->
					$scope.userDisplayName = value
				.catch ->
					$scope.userDisplayName = null

		# Initialize
		$scope.loadUser()
])