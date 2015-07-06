angular.module('app-factory').factory 'EditAttributeModal', ->
	return (attribute) ->
		templateUrl: 'client/modals/edit-attribute-modal.template.html'
		controller: 'EditAttributeModalCtrl'
		keyboard: false
		backdrop: 'static'
		resolve:
			'attribute': -> attribute

angular.module('app-factory').controller('EditAttributeModalCtrl', ['$scope', '$rootScope', '$modalInstance', 'attribute', ($scope, $rootScope, $modalInstance, attribute) ->

	$scope.showValidationErrors = false
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.attributeValueTypes = Utils.mapToArray(DocumentAttribute.VALUE_TYPE)
	$scope.isEdit = attribute?

	$scope.routines = $scope.$meteorCollection -> Routine.db.find('blueprint_id': $rootScope.blueprint['_id'], 'type': Routine.TYPE['Attribute'].value)

	$scope.updateDataType = ->
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type'])
		if type?['configuration']?
			$scope.attribute['configuration'] = _.clone(type['configuration'])
		else
			delete $scope.attribute['configuration']

	$scope.updateValueType = ->
		$scope.attribute['routine_id'] = null if $scope.attribute['value_type'] isnt DocumentAttribute.VALUE_TYPE['Routine'].value

	$scope.shouldShowConfiguration = ->
		type = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type'])
		return true if type?['configuration']?
		return false

	$scope.shouldShowRoutineSelection = ->
		return true if $scope.attribute['value_type'] is DocumentAttribute.VALUE_TYPE['Routine'].value
		return false

	$scope.shouldShowConfigurationTab = ->
		return true if $scope.shouldShowConfiguration()
		return true if $scope.shouldShowRoutineSelection()
		return false

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
			'value_type': DocumentAttribute.VALUE_TYPE['Input'].value
])
