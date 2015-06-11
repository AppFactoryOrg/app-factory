angular.module('app-factory').directive('afAppWidgetButton', ['$meteor', 'toaster', ($meteor, toaster) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-button.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		$scope.click = ->
			id = $scope.widget['configuration']['routine_id']
			return unless id?
			$meteor.call('Routine.execute', {id})
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "#{error.reason}"
						showCloseButton: true
					)
		
])