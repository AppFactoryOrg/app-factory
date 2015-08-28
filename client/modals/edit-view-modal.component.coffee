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

	$scope.submit = ->
		if $scope.form.name.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$scope.view['widget']['configuration']['attributes'] = _.pluck(_.filter($scope.attributes, {'$selected': true}), 'id')
		$scope.view['sort'] = {}
		$scope.view['sort'][$scope.sort.value] = $scope.sort.direction

		$modalInstance.close($scope.view)

	$scope.selectAttribute = (attribute) ->
		attribute.$selected = true

	$scope.deselectAttribute = (attribute) ->
		attribute.$selected = false

	# Initialize
	if view?
		$scope.view = _.cloneDeep(view)

		$scope.attributes = []
		$scope.view['widget']['configuration']['attributes'].forEach (attribute_id) ->
			attribute = _.findWhere($scope.documentSchema['attributes'], {'id': attribute_id})
			return unless attribute
			attribute.$selected = true
			$scope.attributes.push(attribute)

		$scope.documentSchema['attributes'].forEach (attribute) ->
			return if _.contains($scope.view['widget']['configuration']['attributes'], attribute['id'])
			$scope.attributes.push(attribute)

		if $scope.view.sort? and not _.isEmpty($scope.view.sort)
			$scope.sort.value = _.keys($scope.view.sort)[0]
			$scope.sort.direction = _.values($scope.view.sort)[0]

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
			'limit': {}

		$scope.attributes = $scope.documentSchema['attributes']
		$scope.attributes.forEach (attribute) -> attribute.$selected = true
]
