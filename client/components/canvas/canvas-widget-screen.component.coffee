angular.module('app-factory').directive('afCanvasWidgetScreen', ['$rootScope', '$modal', 'GenericModal', ($rootScope, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-screen.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->
		$scope.configureWidget = ->
			$modal.open(new GenericModal(
				title: 'Configure Widget'
				submitAction: 'Save'
				attributes: [
					{
						name: 'screen_schema_id'
						displayAs: 'Screen'
						type: 'select'
						options: ScreenSchema.db.find('blueprint_id': $rootScope.blueprint['_id']).fetch()
						optionsConfig: "screen._id as screen.name for screen in attribute.options"
						required: true
						default: $scope.widget['configuration']['screen_schema_id']
					}
				]
			)).result.then (parameters) ->
				$scope.widget['configuration']['screen_schema_id'] = parameters['screen_schema_id']

		$scope.getScreenName = ->
			screen_schema_id = $scope.widget['configuration']['screen_schema_id']
			if screen_schema_id?
				screen = ScreenSchema.db.findOne(screen_schema_id)
				result = screen?.name

			return result
])