angular.module('app-factory').directive('afLimitsPanel', [ ->
	restrict: 'E'
	templateUrl: 'client/components/app/limits-panel.template.html'
	scope:
		'limits':		'='
		'attributes': 	'='
	link: ($scope, $element) ->

		$scope.isOpen = false
		$scope.parsedLimits = []
		$scope.limits.forEach (limit) ->
			filter = _.keys(limit)[0]
			attribute_id = filter.replace('data.', '')
			attribute = _.findWhere($scope.attributes, {'id': attribute_id})
			return unless attribute?
			$scope.parsedLimits.push
				'attribute': attribute
				'value': limit

		$scope.toggle = ->
			$scope.isOpen = !$scope.isOpen

		$scope.close = ->
			$scope.isOpen = false

		$scope.update = ->
			$scope.close()

		$scope.$on('TOGGLE_LIMITS_PANEL', ->
			$scope.toggle()
		)
])
