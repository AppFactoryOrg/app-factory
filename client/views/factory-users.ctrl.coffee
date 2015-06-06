angular.module('app-factory').controller('FactoryUsersCtrl', ['$scope', '$modal', '$meteor', 'toaster', 'InviteUserModal', ($scope, $modal, $meteor, toaster, InviteUserModal) ->

	$scope.$meteorSubscribe('Users', {'application_id': $scope.application['_id']}).then ->
		$scope.users = $scope.$meteorCollection -> Users.db.find()

	$scope.newUser = ->
		$modal.open(new InviteUserModal()).result.then (parameters) ->
			parameters['application_id'] = $scope.application['_id']
			$meteor.call('User.invite', parameters)
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "User invitation failed. #{error.reason}"
						showCloseButton: true
					)

	$scope.getRole = (user) ->
		entry = _.findWhere(user['profile']['application_roles'], {'application_id': $scope.application['_id']})
		return entry?.role
])