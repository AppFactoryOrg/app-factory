angular.module('app-factory').directive('afFilterPanel', [ ->
	restrict: 'E'
	templateUrl: 'client/components/app/filter-panel.template.html'
	scope:
		'filter':		'='
		'attributes': 	'='
	link: ($scope, $element) ->

		$scope.isOpen = false
		$scope.value = null

		$scope.toggle = ->
			$scope.isOpen = !$scope.isOpen
			$scope.value = _.clone($scope.filter)

		$scope.close = ->
			$scope.isOpen = false

		$scope.update = ->
			$scope.$emit('FILTER_UPDATED', $scope.value)
			$scope.close()

		$scope.$on('TOGGLE_FILTER_PANEL', ->
			$scope.toggle()
		)
])
