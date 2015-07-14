angular.module('app-factory').directive('afAppWidgetTable', ['$rootScope', '$modal', '$meteor', '$timeout', 'toaster', 'EditDocumentModal', 'ViewDocumentModal', ($rootScope, $modal, $meteor, $timeout, toaster, EditDocumentModal, ViewDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-table.template.html'
	replace: true
	scope:
		'widget': 			'='
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
		$scope.errorMessage = ''
		$scope.loadingStartedAt = null
		$scope.shouldShowLoadingTimeout = false

		$scope.sortableOptions =
			orderChanged: -> $scope.collectionWasReordered()

		$scope.documents = []

		$scope.shouldShowFilterOptions = ->
			return false if $scope.filterableAttributes?.length is 0
			return true if $scope.widget['configuration']['show_filter_options']
			return false

		$scope.shouldShowSortOptions = ->
			return false if $scope.sortOptions?.length is 0
			return true if $scope.widget['configuration']['show_sort_options']
			return false

		$scope.shouldShowCreateButton = ->
			return true if $scope.widget['configuration']['show_create_button']
			return false

		$scope.shouldShowEditButtons = ->
			return true if $scope.widget['configuration']['show_edit_buttons']
			return false

		$scope.shouldShowSelectButton = ->
			return true if $scope.widget['configuration']['show_select_button']
			return false

		$scope.shouldAllowReordering = ->
			return true if $scope.widget['configuration']['allow_reordering']
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

		$scope.executeAction = (action, document) ->
			routine_id = action['routine_id']
			environment_id = document['environment_id']
			inputs = [{
				name: 'Document'
				value: document
			}]
			$meteor.call('Routine.execute', {routine_id, inputs, environment_id})
				.finally ->
					$scope.isLoading = false
				.catch (error) ->
					console.error(error)
					toaster.pop(
						type: 'error'
						body: "#{error.reason}"
						showCloseButton: true
					)

		$scope.selectDocument = (document) ->
			$scope.$emit('DOCUMENT_SELECTED', document)

		$scope.loadMore = ->
			$scope.limit += 20 unless $scope.limit >= Config['MAX_TABLE_RECORDS']

		$scope.retry = ->
			switch $scope.widget['configuration']['data_source']['type']
				when ScreenWidget.DATA_SOURCE_TYPE['Database'].value
					$scope.loading = false
					if $scope.limit is INITIAL_LIMIT
						$scope.limit = INITIAL_LIMIT+1
					else
						$scope.limit = INITIAL_LIMIT

		$scope.collectionWasReordered = ->
			console.warn 'refreshing collection'
			_.remove($scope.collection)
			newCollection = _.pluck($scope.documents, '_id')
			newCollection.forEach (id) ->
				$scope.collection.push(id)

		# Initialize
		dataSource = $scope.widget['configuration']['data_source']
		$scope.documentSchema = DocumentSchema.db.findOne(dataSource['document_schema_id'])
		$scope.sortOptions = DocumentSchema.getSortOptions($scope.documentSchema)
		$scope.filterableAttributes = DocumentSchema.getFilterableAttributes($scope.documentSchema)

		switch dataSource['type']
			when ScreenWidget.DATA_SOURCE_TYPE['Database'].value
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

					$scope.$meteorSubscribe('Documents', filter, paging)
						.then ->
							$scope.documents = $scope.$meteorCollection -> Document.db.find(filter, paging)
						.catch (error) ->
							$scope.error = true
							$scope.errorMessage = error.reason
							console.error(error)
						.finally ->
							$scope.loading = false

					$scope.lastLimit = limit
					$scope.lastSort = sort
					$scope.lastFilter = filter
				)

			when ScreenWidget.DATA_SOURCE_TYPE['Fixed'].value
				$scope.collection = dataSource['collection']
				$meteor.autorun($scope, ->
					collection = $scope.getReactively('collection', true)
					filter =
						'_id': {'$in': collection}
						'environment_id': $rootScope.environment['_id']
						'document_schema_id': $scope.documentSchema['_id']

					startedAt = Date.now()
					$scope.loading = true
					$scope.loadingStartedAt = startedAt
					$scope.shouldShowLoadingTimeout = false
					$timeout(->
						if $scope.loading is true and $scope.loadingStartedAt is startedAt
							$scope.shouldShowLoadingTimeout = true
					, LOADING_TIMEOUT)

					$scope.$meteorSubscribe('Documents', filter)
						.then ->
							allDocuments = Document.db.find(filter).fetch()
							collectionDocuments = []
							collection.forEach (id) ->
								document = _.find(allDocuments, {'_id': id})
								document = angular.copy(document)
								collectionDocuments.push(document)
							$scope.documents = collectionDocuments
						.catch (error) ->
							$scope.error = true
							console.error(error)
						.finally ->
							$scope.loading = false
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
