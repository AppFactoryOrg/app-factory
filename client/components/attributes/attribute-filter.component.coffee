angular.module('app-factory').directive('afAttributeFilter', ['$compile', '$timeout', ($compile, $timeout) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/attribute-filter.template.html'
	scope:
		'filter':		'='
		'attribute': 	'='
		'displayOnly': 	'='
	link: ($scope, $element) ->
		attributesEl = $('.filter', $element)

		$scope.$watch 'attribute', (attribute) ->
			attributesEl.empty()
			return unless attribute?

			name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
			childTemplate = "
				<af-attribute-#{name}-filter
					attribute='attribute'
					filter-value='filter'
					display-only='displayOnly'>
				</af-attribute-#{name}-filter>
			"
			attributesEl.append(childTemplate)
			$compile(attributesEl)($scope)
])
