angular.module('app-factory').directive('afSortPanel', [() ->
	restrict: 'E'
	templateUrl: 'client/components/app/sort-panel.template.html'
	scope:
		'sort':					'='
		'options': 			'='
	link: ($scope, $element) ->

		$scope.isOpen = false
		$scope.value = null
		$scope.direction = null
		$scope.sortDirections = [{name: 'Asc', value: 1},{name: 'Desc', value: -1}]

		$scope.toggle = ->
			$scope.isOpen = !$scope.isOpen
			$scope.value = _.keys($scope.sort)[0]
			$scope.direction = _.values($scope.sort)[0]

		$scope.close = ->
			$scope.isOpen = false

		$scope.update = ->
			sort = {}
			sort[$scope.value] = $scope.direction
			$scope.$emit('SORT_UPDATED', sort)
			$scope.close()

		$scope.$on('TOGGLE_SORT_PANEL', ->
			$scope.toggle()
		)
])