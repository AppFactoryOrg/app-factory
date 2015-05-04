angular.module('app-factory').factory 'GenericModal', ->
	return (parameters) ->
		templateUrl: 'client/templates/generic-modal.template.html'
		controller: 'GenericModalCtrl'
		resolve:
			'parameters': -> parameters

angular.module('app-factory').controller 'GenericModalCtrl', ($scope, $modalInstance, parameters) ->

	$scope.parameters = angular.copy(parameters)

	$scope.submit = ->
		result = {}
		result[attribute.name] = attribute.value for attribute in $scope.parameters.attributes
		$modalInstance.close(result)