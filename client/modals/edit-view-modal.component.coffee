angular.module('app-factory').factory 'EditViewModal', ->
	return (view, documentSchema) ->
		templateUrl: 'client/modals/edit-view-modal.template.html'
		controller: 'EditViewModalCtrl'
		keyboard: false
		backdrop: 'static'
		windowClass: 'edit-view-modal-container'
		resolve:
			'view': -> view
			'documentSchema': -> documentSchema

angular.module('app-factory').controller 'EditViewModalCtrl', ['$scope', '$rootScope', '$modalInstance', '$meteor', '$compile', 'view', 'documentSchema', ($scope, $rootScope, $modalInstance, $meteor, $compile, view, documentSchema) ->

	$scope.documentSchema = _.cloneDeep(documentSchema)
	$scope.showValidationErrors = false
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.sortableOptionsAttributes =
		containment: '#sort-bounds-columns'
		containerPositioning: 'relative'
	$scope.sortDirections = [{name: 'Asc', value: 1},{name: 'Desc', value: -1}]
	$scope.sortOptions = DocumentSchema.getSortOptions($scope.documentSchema)
	$scope.sort = {value: 'created_on', direction: -1}
	$scope.allAttributes = DocumentSchema.getAllAttributes($scope.documentSchema)
	$scope.newLimit = {attribute: null, value: {}}
	$scope.limits = []

	$scope.submit = ->
		if $scope.form.name.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$scope.view['widget']['configuration']['attributes'] = _.pluck(_.filter($scope.attributes, {'$selected': true}), 'id')
		$scope.view['sort'] = {}
		$scope.view['sort'][$scope.sort['value']] = $scope.sort['direction']
		$scope.view['limits'] = _.pluck($scope.limits, 'value')

		$modalInstance.close($scope.view)

	$scope.selectAttribute = (attribute) ->
		attribute.$selected = true

	$scope.deselectAttribute = (attribute) ->
		attribute.$selected = false

	$scope.addNewLimit = ->
		$scope.limits.push($scope.newLimit)
		$scope.newLimit = {attribute: null, value: {}}

	$scope.$watch('limits', (limits) ->
		toRemove = []
		limits.forEach (limit) ->
			toRemove.push(limit) if _.isEmpty(limit.value)
		toRemove.forEach (limit) ->
			Utils.removeFromArray(limit, limits)
	, true)

	# Initialize
	if view?
		$scope.view = _.cloneDeep(view)

		$scope.attributes = []
		$scope.view['widget']['configuration']['attributes'].forEach (attribute_id) ->
			attribute = _.findWhere($scope.allAttributes, {'id': attribute_id})
			return unless attribute?
			attribute.$selected = true
			$scope.attributes.push(attribute)

		$scope.allAttributes.forEach (attribute) ->
			return if _.contains($scope.view['widget']['configuration']['attributes'], attribute['id'])
			$scope.attributes.push(attribute)

		if $scope.view.sort? and not _.isEmpty($scope.view['sort'])
			$scope.sort.value = _.keys($scope.view['sort'])[0]
			$scope.sort.direction = _.values($scope.view['sort'])[0]

		$scope.view['limits'].forEach (limit) ->
			data_key = _.keys(limit)[0]
			attribute = _.find($scope.allAttributes, (attribute) -> DocumentAttribute.getDataKey(attribute) is data_key)
			return unless attribute?
			$scope.limits.push
				'attribute': attribute
				'value': limit

	else
		widget = ScreenWidget.new({type: ScreenWidget.TYPE['Table'].value})
		widget['name'] = ''
		widget['configuration']['show_name'] = false
		widget['configuration']['data_source']['type'] = ScreenWidget.DATA_SOURCE_TYPE['Database'].value
		widget['configuration']['data_source']['document_schema_id'] = $scope.documentSchema['_id']
		widget['configuration']['data_source']['attributes'] = []

		$scope.view =
			'widget': widget
			'filter': {}
			'sort': {'created_on': -1}
			'limits': []

		$scope.attributes = _.cloneDeep($scope.allAttributes)
		$scope.attributes.forEach (attribute) ->
			attribute.$selected = attribute['id'] isnt 'created_by' and attribute['id'] isnt 'created_on'
]
