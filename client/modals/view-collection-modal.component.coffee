angular.module('app-factory').factory 'ViewCollectionModal', ->
	return ({name, collection, documentSchema, options}) ->
		templateUrl: 'client/modals/view-collection-modal.template.html'
		controller: 'ViewCollectionModalCtrl'
		size: 'lg'
		resolve:
			'name': -> name
			'collection': -> collection
			'documentSchema': -> documentSchema
			'options': -> options or {}

angular.module('app-factory').controller('ViewCollectionModalCtrl', ['$scope', '$modal', '$modalInstance', 'SelectDocumentModal', 'name', 'collection', 'documentSchema', 'options', ($scope, $modal, $modalInstance, SelectDocumentModal, name, collection, documentSchema, options) ->
	$scope.documentSchema = documentSchema
	$scope.editMode = options['edit'] is true

	$scope.widget = ScreenWidget.new({type: ScreenWidget.TYPE['Table'].value})
	$scope.widget['name'] = "#{name}"
	$scope.widget['configuration']['data_source']['type'] = ScreenWidget.DATA_SOURCE_TYPE['Fixed'].value
	$scope.widget['configuration']['data_source']['document_schema_id'] = documentSchema['_id']
	$scope.widget['configuration']['data_source']['collection'] = collection
	$scope.widget['configuration']['show_filter_options'] = false
	$scope.widget['configuration']['show_sort_options'] = false
	$scope.widget['configuration']['show_create_button'] = false
	$scope.widget['configuration']['show_edit_buttons'] = false
	$scope.widget['configuration']['show_select_button'] = false
	$scope.widget['configuration']['allow_reordering'] = options['edit'] is true

	$scope.addItem = ->
		$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
			collection.unshift(document['_id'])
])
