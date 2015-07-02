angular.module('app-factory').directive('afAttributeUserFilter', ['$modal', 'SelectUserModal', 'UserUtils', ($modal, SelectUserModal, UserUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/user/attribute-user-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"
		operators = DocumentAttribute.DATA_TYPE['User'].operators

		$scope.operatorOptions = _.values(operators)
		$scope.operator = null
		$scope.value = null
		$scope.userDisplayName = ''

		$scope.lookupUser = ->
			$modal.open(new SelectUserModal()).result.then (user) ->
				$scope.value = user['_id']
				$scope.operator = operators['is']
				$scope.updateFilterValue()
				$scope.loadUser()

		$scope.loadUser = ->
			userId = $scope.value
			UserUtils.getUserName(userId)
				.then (value) ->
					$scope.userDisplayName = value
				.catch ->
					$scope.userDisplayName = ''

		$scope.hasValue = ->
			return true if $scope.value isnt null
			return true if $scope.operator isnt null
			return false

		$scope.clear = ->
			$scope.value = null
			$scope.operator = null
			$scope.userDisplayName = ''
			delete $scope.filterValue[key]

		$scope.updateFilterValue = ->
			value = $scope.value
			operator = $scope.operator

			if not operator? and value?
				$scope.operator = operator = operators['is']

			$scope.filterValue[key] = value

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.operator = null
				$scope.value = null
				$scope.userDisplayName = ''
				return

			$scope.value = $scope.filterValue[key]
			$scope.operator = operators['is']
			$scope.loadUser()
		)
])
