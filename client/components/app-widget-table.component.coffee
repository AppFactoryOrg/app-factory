angular.module('app-factory').directive('afAppWidgetTable', ['$rootScope', '$modal', '$meteor', 'EditDocumentModal', ($rootScope, $modal, $meteor, EditDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-table.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		$scope.pageSize = 10
		$scope.pageNumber = 1

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
			$meteor.call('Document.delete', document['_id'])

		$scope.nextPage = ->
			$scope.pageNumber++
		$scope.prevPage = ->
			$scope.pageNumber--
			$scope.pageNumber = 1 if $scope.pageNumber < 1

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
						'page_number': $scope.getReactively('pageNumber')
						'page_size': $scope.getReactively('pageSize')
					$meteor.subscribe('Document', $scope.documentParams, paging).then ->
						limit = paging['page_size']
						skip = limit*(paging['page_number']-1)
						sort = {'created_on': -1}
						$scope.documents = $meteor.collection -> Document.db.find($scope.documentParams, {limit, skip, sort})

])