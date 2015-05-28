angular.module('app-factory').directive('afFilterPanel', ['$compile', ($compile) ->
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

		# Initialize
		$scope.attributes.forEach (attribute, index) ->
			name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
			childTemplate = "
				<af-attribute-#{name}-filter
					attribute='attributes[#{index}]'
					filter-value='value'>
				</af-attribute-#{name}-filter>
			"
			attributesEl = $('.filters', $element)
			attributesEl.append(childTemplate)
			$compile(attributesEl)($scope)

		$scope.$on('TOGGLE_FILTER_PANEL', ->
			$scope.toggle()
		)
])