angular.module('app-factory').controller('AccountCtrl', ['$scope', '$rootScope', '$meteor', '$state', '$modal', 'GenericModal', ($scope, $rootScope, $meteor, $state, $modal, GenericModal) ->

	$scope.$meteorSubscribe('Application')
	$scope.applications = $scope.$meteorCollection -> Application.db.find()

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

	$scope.userCanEditApplication = (application) ->
		user = $rootScope.currentUser
		application_id = application['_id']
		return User.canEditApplication({user, application_id})

	$scope.createApplication = ->
		$modal.open(new GenericModal(
			title: 'New Application'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
			]
		)).result.then (application) ->
			$meteor.call('Application.create', application)

])