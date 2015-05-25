angular.module('app-factory').directive('afAppWidgetTable', ['$rootScope', '$modal', '$meteor', 'EditDocumentModal', 'ViewDocumentModal', ($rootScope, $modal, $meteor, EditDocumentModal, ViewDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-table.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		$scope.limit = 20
		$scope.sort = {'created_on': -1}

		$scope.addDocument = ->
			documentSchema = $scope.documentSchema
			modal = $modal.open(new EditDocumentModal({documentSchema}))
			modal.result.then (document) ->
				$meteor.call('Document.create', document)

		$scope.viewDocument = (document) ->
			documentSchema = $scope.documentSchema
			$modal.open(new ViewDocumentModal({document, documentSchema}))

		$scope.editDocument = (document) ->
			documentSchema = $scope.documentSchema
			modal = $modal.open(new EditDocumentModal({document, documentSchema}))
			modal.result.then (document) ->
				$meteor.call('Document.update', document)

		$scope.deleteDocument = (document) ->
			return unless confirm('Are you sure you want to delete this record? This action cannot be undone.')
			$meteor.call('Document.delete', document['_id'])

		$scope.loadMore = ->
			$scope.limit += 20

		$scope.shouldShowMoreLink = ->
			return false unless $scope.documents?
			return false if $scope.documents.length < $scope.limit
			return true

		# Initialize
		data_source = $scope.widget['configuration']['data_source']
		switch data_source['type']
			when ViewWidget.DATA_SOURCE_TYPE['Document'].value
				$scope.documentSchema = DocumentSchema.db.findOne(data_source['document_schema_id'])
			
				$scope.documentParams = 
						'environment_id': $rootScope.environment['_id']
						'document_schema_id': $scope.documentSchema['_id']

				$meteor.autorun $scope, ->
					paging = 
						'limit': $scope.getReactively('limit')
						'sort': $scope.getReactively('sort')
					$meteor.subscribe('Document', $scope.documentParams, paging).then ->
						$scope.documents = $meteor.collection -> Document.db.find($scope.documentParams, paging)

])