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

	$scope.updateConfiguration = ->
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type'])
		if type?['configuration']?
			$scope.attribute['configuration'] = _.clone(type['configuration'])
		else
			delete $scope.attribute['configuration']

	$scope.shouldShowConfiguration = ->
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type'])
		return type['configuration']?

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$modalInstance.close($scope.attribute)

	# Initialize
	if attribute?
		$scope.attribute = _.clone(attribute)
	else
		$scope.attribute =
			'name': null
			'data_type': null
			'value_type': null
])