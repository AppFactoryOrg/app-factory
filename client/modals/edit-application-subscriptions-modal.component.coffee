angular.module('app-factory').factory 'EditApplicationSubscriptionsModal', ->
	return ({application, billingInfo}) ->
		templateUrl: 'client/modals/edit-application-subscriptions-modal.template.html'
		controller: 'EditApplicationSubscriptionsModalCtrl'
		resolve:
			'application': -> application
			'billingInfo': -> billingInfo

angular.module('app-factory').controller('EditApplicationSubscriptionsModalCtrl', ['$scope', '$filter', '$meteor', '$modalInstance', 'application', 'billingInfo', ($scope, $filter, $meteor, $modalInstance, application, billingInfo) ->
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
			'plan':
				'id': 'free'
				'amount': 0

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


	$scope.getTotalCost = ->
		amount = 0

		subscriptions = [$scope.mainSubscription, $scope.usersSubscription, $scope.databaseSubscription]
		subscriptions.forEach (sub) ->
			amount += sub['quantity'] * sub['plan']['amount']

		return amount / 100

	$scope.submit = ->
		$scope.loading = true

])
