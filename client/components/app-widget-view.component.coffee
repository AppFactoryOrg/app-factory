angular.module('app-factory').directive('afAppWidgetView', ['$meteor', ($meteor) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-view.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		view_schema_id = $scope.widget['configuration']['view_schema_id']
		$meteor.subscribe('ViewSchema', {view_schema_id}).then ->
			$scope.childViewSchema = ViewSchema.db.findOne(view_schema_id)
])