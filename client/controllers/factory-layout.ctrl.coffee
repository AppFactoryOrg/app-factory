angular.module('app-factory').controller('FactoryLayoutCtrl', ['$scope', '$rootScope', '$meteor', '$modal', 'EditNavigationItemModal', ($scope, $rootScope, $meteor, $modal, EditNavigationItemModal) ->

	$scope.originalLayout = $rootScope.blueprint['layout']
	$scope.layout = $rootScope.blueprint['layout']
	$scope.navigationItemTypes = Utils.mapToArray(NavigationItem.TYPE)
	$scope.views = $meteor.collection -> ViewSchema.db.find('blueprint_id': $rootScope.blueprint['_id'])
	$scope.editMode = false
	$scope.sortableOptions =
		containment: '#sort-bounds'
		containerPositioning: 'relative'

	$scope.startEditLayout = ->
		$scope.editMode = true
		$scope.layout = angular.copy($scope.originalLayout)

	$scope.cancelEditLayout = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.layout = $scope.originalLayout

	$scope.saveLayout = ->
		$rootScope.blueprint['layout'] = angular.copy($scope.layout)
		$meteor.call('Blueprint.update', $rootScope.blueprint).then ->
			$scope.editMode = false
			$scope.originalLayout = $scope.layout

	$scope.addNavigationItem = ->
		$modal.open(new EditNavigationItemModal()).result.then (parameters) ->
			navigationItem = NavigationItem.new(parameters)
			$scope.layout['navigation_items'].push(navigationItem)

	$scope.editNavigationitem = (navigationItem) ->
		$modal.open(new EditNavigationItemModal(navigationItem)).result.then (parameters) ->
			_.assign(navigationItem, parameters)
 
	$scope.deleteNavigationItem = (navigationItem) ->
		return unless confirm('Are you sure you want to delete this navigation item?')
		Utils.removeFromArray(navigationItem, $scope.layout['navigation_items'])

	$scope.getNavigationItemDescription = (navigationItem) ->
		switch navigationItem['type']
			when NavigationItem.TYPE['View'].value
				view = ViewSchema.db.findOne(navigationItem['view_id'])
				name = "View - #{view.name}" if view?
			when NavigationItem.TYPE['Link'].value
				name = "Link - #{navigationItem['url']}"

		return name

	$scope.getHomeViewName = ->
		view = ViewSchema.db.findOne($scope.layout['home_view_id'])
		return "(none)" unless view?
		return view?.name
])