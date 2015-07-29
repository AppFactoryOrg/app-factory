angular.module('app-factory').controller('AccountBillingCtrl', ['$scope', '$rootScope', '$meteor', '$state', '$modal', 'billingInfo', ($scope, $rootScope, $meteor, $state, $modal, billingInfo) ->

	$scope.billingInfo = billingInfo

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

])
