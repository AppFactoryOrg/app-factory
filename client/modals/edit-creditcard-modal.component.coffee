angular.module('app-factory').factory 'EditCreditCardModal', ->
	return ->
		templateUrl: 'client/modals/edit-creditcard-modal.template.html'
		controller: 'EditCreditCardModalCtrl'
		keyboard: false
		backdrop: 'static'
		size: 'sm'

angular.module('app-factory').controller 'EditCreditCardModalCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', ($scope, $rootScope, $modalInstance, $meteor) ->

	$scope.showValidationErrors = false

	$scope.submit = ->
		$scope.errorMessage = null

		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		Stripe.card.createToken($scope.creditCard, (status, response) -> $scope.$apply ->
			if status is 200
				token = response['id']
				$modalInstance.close(token)
			else
				$scope.errorMessage = response['error']['message']
		)

	# Initialize
	$scope.creditCard =
		'number': null
		'exp_month': null
		'exp_year': null
		'cvc': null
		'address_zip': null
]
