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
			id = $scope.widget['configuration']['routine_id']
			return unless id?
			$scope.isLoading = true
			$meteor.call('Routine.execute', {id})
				.finally ->
					$scope.isLoading = false
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "#{error.reason}"
						showCloseButton: true
					)
		
])