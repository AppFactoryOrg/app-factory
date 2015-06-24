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

		$scope.isLoading = false

		$scope.click = ->
			routine_id = $scope.widget['configuration']['routine_id']
			return unless routine_id?
			
			$scope.isLoading = true
			$meteor.call('Routine.execute', {routine_id})
				.finally ->
					$scope.isLoading = false
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "#{error.reason}"
						showCloseButton: true
					)
		
])