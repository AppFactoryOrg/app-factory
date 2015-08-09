angular.module('app-factory').factory 'EditApplicationSubscriptionsModal', ->
	return ({application, billingInfo}) ->
		templateUrl: 'client/modals/edit-application-subscriptions-modal.template.html'
		controller: 'EditApplicationSubscriptionsModalCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'application': -> application
			'billingInfo': -> billingInfo

angular.module('app-factory').controller('EditApplicationSubscriptionsModalCtrl', ['$scope', '$filter', '$meteor', '$modalInstance', 'toaster', 'application', 'billingInfo', ($scope, $filter, $meteor, $modalInstance, toaster, application, billingInfo) ->
	$scope.application = application

	$scope.plans = _.filter(billingInfo['plans'], (plan) ->
		return false unless plan['metadata']['type'] is 'main'
		return true
	)
	$scope.plans.push
		'id': 'free'
		'name': 'Free'
		'amount': 0
		'metadata':
			'type': 'main'
			'base_users': 3
			'base_mb': 3
			'max_users': 3
			'max_db': 3
	$scope.plans.forEach (plan) ->
		amount = $filter('currency')(plan['amount'] / 100)
		plan['$name'] = "#{plan.name} - #{amount}/mo"

	$scope.loading = false

	$scope.mainSubscription = _.findWhere(billingInfo['subscriptions'], (sub) ->
		return false unless sub['metadata']['application_id'] is application['_id']
		return false unless sub['metadata']['type'] is 'main'
		return true
	)

	unless $scope.mainSubscription?
		$scope.mainSubscription =
			'quantity': 1
			'plan': _.findWhere($scope.plans, {'id': 'free'})

	$scope.usersSubscription = _.findWhere(billingInfo['subscriptions'], (sub) ->
		return false unless sub['metadata']['application_id'] is application['_id']
		return false unless sub['metadata']['type'] is 'users'
		return true
	)

	unless $scope.usersSubscription?
		$scope.usersSubscription =
			'quantity': 0
			'plan': _.findWhere(billingInfo['plans'], {'id': 'users'})

	$scope.databaseSubscription = _.findWhere(billingInfo['subscriptions'], (sub) ->
		return false unless sub['metadata']['application_id'] is application['_id']
		return false unless sub['metadata']['type'] is 'database'
		return true
	)

	unless $scope.databaseSubscription?
		$scope.databaseSubscription =
			'quantity': 0
			'plan': _.findWhere(billingInfo['plans'], {'id': 'database'})

	$scope.mainSubscriptionChanged = ->
		$scope.usersSubscription['quantity'] = 0
		$scope.databaseSubscription['quantity'] = 0

	$scope.getTotalCost = ->
		amount = 0

		subscriptions = [$scope.mainSubscription, $scope.usersSubscription, $scope.databaseSubscription]
		subscriptions.forEach (sub) ->
			amount += sub['quantity'] * sub['plan']['amount']

		return amount / 100

	$scope.shouldShowUserScale = ->
		return false if $scope.mainSubscription['plan']['id'] is 'free'
		return true

	$scope.shouldShowDatabaseScale = ->
		return false if $scope.mainSubscription['plan']['id'] is 'free'
		return true

	$scope.getMaxUsersQuantity = ->
		base_users = Number($scope.mainSubscription['plan']['metadata']['base_users'])
		max_users = Number($scope.mainSubscription['plan']['metadata']['max_users'])
		users_per_quantity = Number($scope.usersSubscription['plan']['metadata']['users_per_quantity'])
		return (max_users-base_users) / users_per_quantity

	$scope.getUsersInPlan = ->
		base_users = Number($scope.mainSubscription['plan']['metadata']['base_users'])
		users_per_quantity = Number($scope.usersSubscription['plan']['metadata']['users_per_quantity'])
		additional_user_quantity = Number($scope.usersSubscription['quantity'])
		return base_users + (additional_user_quantity * users_per_quantity)

	$scope.getMbInPlan = ->
		base_mb = Number($scope.mainSubscription['plan']['metadata']['base_mb'])
		mb_per_quantity = Number($scope.databaseSubscription['plan']['metadata']['mb_per_quantity'])
		additional_mb_quantity = Number($scope.databaseSubscription['quantity'])
		return base_mb + (additional_mb_quantity * mb_per_quantity)

	$scope.getMaxDatabaseQuantity = ->
		base_mb = Number($scope.mainSubscription['plan']['metadata']['base_mb'])
		max_mb = Number($scope.mainSubscription['plan']['metadata']['max_mb'])
		mb_per_quantity = Number($scope.databaseSubscription['plan']['metadata']['mb_per_quantity'])
		return (max_mb-base_mb) / mb_per_quantity

	$scope.submit = ->
		$scope.loading = true

		subscriptions = [$scope.mainSubscription, $scope.usersSubscription, $scope.databaseSubscription]
		$meteor.call('Billing.updateSubscriptions', {application, subscriptions})
			.then -> $modalInstance.close()
			.finally -> $scope.loading = false
			.catch (error) ->
				toaster.pop(
					type: 'error'
					body: "Could not update subscription. #{error.reason}"
					showCloseButton: true
				)
])
