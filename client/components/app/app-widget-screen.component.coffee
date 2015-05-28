angular.module('app-factory').directive('afAppWidgetScreen', ['$meteor', ($meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-screen.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		screen_schema_id = $scope.widget['configuration']['screen_schema_id']
		childScreenSchema = ScreenSchema.db.findOne(screen_schema_id)
		ScreenSchema.buildWidgetHierarchy(childScreenSchema)
		$scope.childScreenSchema = childScreenSchema
])