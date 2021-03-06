angular.module('app-factory').controller('AccountApplicationsCtrl', ['$scope', '$rootScope', '$meteor', '$state', '$modal', 'toaster', 'GenericModal', ($scope, $rootScope, $meteor, $state, $modal, toaster, GenericModal) ->

	$meteor.autorun($scope, ->
		currentUser = $scope.getReactively('currentUser')
		return unless currentUser?
		applicationIds = _.pluck(currentUser['profile']['application_roles'], 'application_id')
		$scope.$meteorSubscribe('Applications', applicationIds)
			.then ->
				$scope.applications = $scope.$meteorCollection -> Application.db.find()
	)

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

	$scope.shouldShowBilling = ->
		return Meteor.settings.public.billing_is_enabled

	$scope.userCanEditApplication = (application) ->
		user_id = $rootScope.currentUser['_id']
		application_id = application['_id']
		return User.canAccessApplication(user_id, application_id, true)

	$scope.userIsApplicationOwner = (application) ->
		user = $rootScope.currentUser
		return User.isApplicationOwner({user, application})

	$scope.createApplication = ->
		$modal.open(new GenericModal(
			title: 'New Application'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
			]
		)).result.then (application) ->
			$meteor.call('Application.create', application)
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "Could not create Application: #{error.reason}"
						showCloseButton: true
					)
])
