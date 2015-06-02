angular.module('app-factory').directive('afAppWidgetTable', ['$rootScope', '$modal', '$meteor', '$timeout', 'EditDocumentModal', 'ViewDocumentModal', ($rootScope, $modal, $meteor, $timeout, EditDocumentModal, ViewDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-table.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 			'='
		'parent':			'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		INITIAL_LIMIT = 20
		LOADING_TIMEOUT = 3000

		$scope.limit = INITIAL_LIMIT
		$scope.sort = {'created_on': -1}
		$scope.filter = {}

		$scope.lastLimit = null
		$scope.lastSort = null
		$scope.lastFilter = null

		$scope.loading = false
		$scope.error = false
		$scope.loadingStartedAt = null
		$scope.shouldShowLoadingTimeout = false

		$scope.documents = []

		$scope.shouldShowEditButtons = ->
			return true if $scope.widget['configuration']['show_edit_buttons']
			return false

		$scope.shouldShowSelectButton = ->
			return true if $scope.widget['configuration']['show_select_button']
			return false

		$scope.shouldShowMoreLink = ->
			return false if $scope.loading
			return false unless $scope.documents?
			return false if $scope.documents.length < $scope.limit
			return false if $scope.documents.length >= Config['MAX_TABLE_RECORDS']
			return true

		$scope.shouldShowTooMuchDataWarning = ->
			return false if $scope.loading
			return true if $scope.documents.length >= Config['MAX_TABLE_RECORDS']
			return false

		$scope.toggleSortPanel = ->
			$scope.$broadcast('TOGGLE_SORT_PANEL')

		$scope.toggleFilterPanel = ->
			$scope.$broadcast('TOGGLE_FILTER_PANEL')

		$scope.loadMore = ->
			$scope.limit += 20 unless $scope.limit >= Config['MAX_TABLE_RECORDS']

		$scope.retry = ->
			switch data_source['type']
				when ScreenWidget.DATA_SOURCE_TYPE['Document'].value
					$scope.loading = false
					if $scope.limit is INITIAL_LIMIT
						$scope.limit = INITIAL_LIMIT+1
					else
						$scope.limit = INITIAL_LIMIT

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

		$scope.selectDocument = (document) ->
			$scope.$emit('DOCUMENT_SELECTED', document)

		# Initialize
		data_source = $scope.widget['configuration']['data_source']
		switch data_source['type']
			when ScreenWidget.DATA_SOURCE_TYPE['Document'].value
				$scope.documentSchema = DocumentSchema.db.findOne(data_source['document_schema_id'])
				$scope.sortOptions = DocumentSchema.getSortOptions($scope.documentSchema)
				$scope.filterableAttributes = DocumentSchema.getFilterableAttributes($scope.documentSchema)

				$meteor.autorun($scope, ->
					limit = $scope.getReactively('limit')
					sort = $scope.getReactively('sort')
					filter = $scope.getReactively('filter')

					paging = {limit, sort}
					_.assign(filter, {
						'environment_id': $rootScope.environment['_id']
						'document_schema_id': $scope.documentSchema['_id']
					})

					unless _.isEqual(limit, $scope.lastLimit) and _.isEqual(sort, $scope.lastSort) and _.isEqual(filter, $scope.lastFilter)
						startedAt = Date.now()
						$scope.loading = true
						$scope.loadingStartedAt = startedAt
						$scope.shouldShowLoadingTimeout = false
						$timeout(->
							if $scope.loading is true and $scope.loadingStartedAt is startedAt
								$scope.shouldShowLoadingTimeout = true
						, LOADING_TIMEOUT)

					$meteor.subscribe('Documents', filter, paging)
						.then ->
							$scope.documents = $meteor.collection -> Document.db.find(filter, paging)
						.catch (error) ->
							$scope.error = true
							console.error(error)
						.finally ->
							$scope.loading = false

					$scope.lastLimit = limit
					$scope.lastSort = sort
					$scope.lastFilter = filter
				)

		$scope.$on('SORT_UPDATED', (event, sort) ->
			$scope.sort = sort
			$scope.limit = INITIAL_LIMIT
			$('.table-scroll', $element).scrollTop(0)
			event.stopPropagation()
		)

		$scope.$on('FILTER_UPDATED', (event, filter) ->
			$scope.filter = filter
			$scope.limit = INITIAL_LIMIT
			$('.table-scroll', $element).scrollTop(0)
			event.stopPropagation()
		)
])