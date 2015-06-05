angular.module('app-factory').factory('InviteUserModal', ->
	return ->
		templateUrl: 'client/modals/invite-user-modal.template.html'
		controller: 'InviteUserModalCtrl'
)

angular.module('app-factory').controller('InviteUserModalCtrl', ['$scope', '$modalInstance', ($scope, $modalInstance) ->

	$scope.showValidationErrors = false
	$scope.user = 
		'name': ''
		'email': ''

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
		else
			$scope.showValidationErrors = false
			$modalInstance.close($scope.user)
])
