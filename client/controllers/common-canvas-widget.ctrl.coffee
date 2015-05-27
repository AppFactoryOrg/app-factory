angular.module('app-factory').controller('CommonCanvasWidgetCtrl', ['$scope', ($scope) ->

	$scope.icon = _.findWhere(ViewWidget.TYPE, 'value': $scope.widget['type']).icon

	$scope.deleteWidget = ->
		return unless confirm("Are you sure you want to delete this widget?")
		
		if $scope.parent?
			Utils.removeFromArray($scope.widget, $scope.parent['$childWidgets'])
		else
			Utils.removeFromArray($scope.widget, $scope.viewSchema['$rootWidgets'])
		
		$scope.$emit('CANVAS_WIDGET_DELETED', $scope.widget)

])