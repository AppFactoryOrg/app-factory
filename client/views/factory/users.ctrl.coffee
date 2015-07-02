angular.module('app-factory').controller('FactoryUsersCtrl', ['$scope', '$rootScope', '$modal', '$meteor', 'toaster', 'InviteUserModal', ($scope, $rootScope, $modal, $meteor, toaster, InviteUserModal) ->

	$scope.$meteorSubscribe('Users', {'application_id': $scope.application['_id']}).then ->
		$scope.users = $scope.$meteorCollection -> User.db.find()

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

	$scope.shouldShowRevoke = (user) ->
		return false if user['_id'] is $rootScope.currentUser['_id']
		return true

	$scope.revokeUser = (user) ->
		return unless confirm('Are you sure you want to remove this user from the application?')

		user_id = user['_id']
		application_id = $scope.application['_id']
		$meteor.call('User.revoke', {user_id, application_id})
			.catch (error) ->
				toaster.pop(
					type: 'error'
					body: "Could not remove user. #{error.reason}"
					showCloseButton: true
				)
])