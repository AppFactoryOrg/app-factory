angular.module('app-factory').factory 'GenericModal', ->
	return (parameters) ->
		templateUrl: 'client/templates/generic-modal.template.html'
		controller: 'GenericModalCtrl'
		resolve:
			'parameters': -> parameters

angular.module('app-factory').controller 'GenericModalCtrl', ($scope, $modalInstance, parameters) ->

	$scope.parameters = angular.copy(parameters)
	$scope.showValidationErrors = false

	$scope.result = {}
	_.each $scope.parameters.attributes, (attribute) ->
		if attribute['type'] is 'select'
			$scope.result[attribute.name] = attribute.options[0].value
			attribute.optionsConfig = "option.value as option.name for option in attribute.options | orderBy:option.value" unless attribute.optionsConfig?
		if attribute['default']?
			$scope.result[attribute.name] = attribute['default']

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false
			
		$modalInstance.close($scope.result)