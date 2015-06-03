angular.module('app-factory').controller('AccountCtrl', ['$scope', '$meteor', '$state', '$modal', 'GenericModal', ($scope, $meteor, $state, $modal, GenericModal) ->

	$scope.$meteorSubscribe('Application')
	$scope.applications = $scope.$meteorCollection -> Application.db.find()

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

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