angular.module('app-factory').factory 'SelectUserModal', ->
	return ->
		templateUrl: 'client/modals/select-user-modal.template.html'
		controller: 'SelectUserModalCtrl'

angular.module('app-factory').controller('SelectUserModalCtrl', ['$scope', '$rootScope', '$modalInstance', ($scope, $rootScope, $modalInstance) ->

	application_id = $rootScope.application['_id']
	$scope.users = $scope.$meteorCollection -> User.db.find('profile.application_roles.application_id': application_id)
	$scope.$meteorSubscribe('Users', {application_id})

	$scope.selectUser = (user) ->
		$modalInstance.close(user)
])
