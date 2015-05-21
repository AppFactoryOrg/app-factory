angular.module('app-factory').directive('afAppWidgetTable', ['$modal', '$meteor', 'EditDocumentModal', ($modal, $meteor, EditDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-table.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		$scope.addDocument = ->
			documentSchema = $scope.documentSchema
			modal = $modal.open(new EditDocumentModal({documentSchema}))
			modal.result.then (document) ->
				$meteor.call('Document.create', document)

		$scope.editDocument = (document) ->
			documentSchema = $scope.documentSchema
			modal = $modal.open(new EditDocumentModal({document, documentSchema}))
			modal.result.then (document) ->
				$meteor.call('Document.update', document)

		$scope.deleteDocument = (document) ->
			return unless confirm('Are you sure you want to delete this record? This action cannot be undone.')
				$meteor.call('Document.delete', document)

		# Initialize
		data_source = $scope.widget['configuration']['data_source']
		switch data_source['type']
			when ViewWidget.DATA_SOURCE_TYPE['Document'].value
				document_schema_id = data_source['document_schema_id']
				$scope.documentSchema = DocumentSchema.db.findOne(document_schema_id)
])