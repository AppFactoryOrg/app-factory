angular.module('app-factory').factory 'EditAttributeModal', ->
	return (attribute) ->
		templateUrl: 'client/modals/edit-attribute-modal.template.html'
		controller: 'EditAttributeModalCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'attribute': -> attribute

angular.module('app-factory').controller('EditAttributeModalCtrl', ['$scope', '$modalInstance', 'attribute', ($scope, $modalInstance, attribute) ->

	$scope.showValidationErrors = false
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.attributeValueTypes = Utils.mapToArray(DocumentAttribute.VALUE_TYPE)
	$scope.isEdit = attribute?

	if attribute?
		$scope.attribute = _.clone(attribute)
	else
		$scope.attribute =
			'name': null
			'data_type': null
			'value_type': null

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.attribute)

])