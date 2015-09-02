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
			data_key = _.keys(limit)[0]
			attribute = _.find($scope.attributes, (attribute) -> DocumentAttribute.getDataKey(attribute) is data_key)
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
