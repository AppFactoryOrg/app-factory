angular.module('app-factory').controller('AccountBillingCtrl', ['$scope', '$meteor', '$state', '$modal', 'toaster', 'EditCreditCardModal', 'EditApplicationSubscriptionsModal', ($scope, $meteor, $state, $modal, toaster, EditCreditCardModal, EditApplicationSubscriptionsModal) ->

	$scope.loading = false

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

	$scope.shouldShowBilling = ->
		return Meteor.settings.public.billing_is_enabled

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

	$scope.editApplication = (application) ->
		billingInfo = _.cloneDeep($scope.billingInfo)
		modal = $modal.open(new EditApplicationSubscriptionsModal({application, billingInfo}))
		modal.result.then ->
			$scope.refreshBillingInfo()

	$scope.getApplicationPlanName = (application) ->
		subscription = _.find($scope.billingInfo['subscriptions'], (sub) ->
			return false unless sub['metadata']['application_id'] is application['_id']
			return false unless sub['plan']['metadata']['type'] is 'main'
			return true
		)

		if subscription?
			return subscription['plan']['name']
		else
			return 'Free'

	$scope.getApplicationPlanCost = (application) ->
		amount = 0

		subscriptions = _.filter($scope.billingInfo['subscriptions'], (sub) ->
			return false unless sub['metadata']['application_id'] is application['_id']
			return true
		)
		subscriptions.forEach (sub) ->
			amount += sub['quantity'] * sub['plan']['amount']


		return amount / 100

	$scope.getTotalCost = ->
		amount = 0

		$scope.billingInfo['subscriptions'].forEach (sub) ->
			amount += sub['quantity'] * sub['plan']['amount']


		return amount / 100

	# Initialize
	$scope.refreshBillingInfo()
])
