angular.module('app-factory').directive('afCanvasWidgetView', ['$rootScope', '$modal', 'GenericModal', ($rootScope, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-view.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->
		$scope.configureWidget = ->
			$modal.open(new GenericModal(
				title: 'Configure View Widget'
				submitAction: 'Save'
				attributes: [
					{
						name: 'view_schema_id'
						displayAs: 'View'
						type: 'select'
						options: ViewSchema.db.find('blueprint_id': $rootScope.blueprint['_id']).fetch()
						optionsConfig: "view._id as view.name for view in attribute.options"
						required: true
						default: $scope.widget['configuration']['view_schema_id']
					}
				]
			)).result.then (parameters) ->
				$scope.widget['configuration']['view_schema_id'] = parameters['view_schema_id']

		$scope.getViewName = ->
			view_schema_id = $scope.widget['configuration']['view_schema_id']
			if view_schema_id?
				view = ViewSchema.db.findOne(view_schema_id)
				result = view?.name

			return result
])