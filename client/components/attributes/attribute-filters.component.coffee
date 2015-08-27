angular.module('app-factory').directive('afAttributeFilters', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/attribute-filters.template.html'
	scope:
		'filter':		'='
		'attributes': 	'='
	link: ($scope, $element) ->
		$scope.attributes.forEach (attribute, index) ->
			name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
			childTemplate = "
				<af-attribute-#{name}-filter
					attribute='attributes[#{index}]'
					filter-value='filter'>
				</af-attribute-#{name}-filter>
			"
			attributesEl = $('.filters', $element)
			attributesEl.append(childTemplate)
			$compile(attributesEl)($scope)
])
