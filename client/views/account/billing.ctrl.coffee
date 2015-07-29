angular.module('app-factory').controller('AccountBillingCtrl', ['$scope', '$meteor', '$state', '$modal', 'toaster', 'billingInfo', 'EditCreditCardModal', ($scope, $meteor, $state, $modal, toaster, billingInfo, EditCreditCardModal) ->

	$scope.billingInfo = billingInfo
	$scope.loading = false

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

	$scope.editCreditCard = ->
		modal = $modal.open(new EditCreditCardModal())
		modal.result.then (token) ->
			$scope.loading = true
			$meteor.call('Billing.updateCreditCard', token)
				.then ->
					$scope.refreshBillingInfo()
				.catch (error) ->
					$scope.loading = false
					console.error(error)
					toaster.pop(
						type: 'error'
						body: "Failed to authorize credit card. #{error}"
						showCloseButton: true
					)

	$scope.refreshBillingInfo = ->
		$scope.loading = true
		$meteor.call('Billing.getUserInfo')
			.then (billingInfo) ->
				$scope.billingInfo = billingInfo
			.finally ->
				$scope.loading = false
			.catch (error) ->
				console.error(error)
				toaster.pop(
					type: 'error'
					body: "Failed to fetch billing info. #{error}"
					showCloseButton: true
				)
])
