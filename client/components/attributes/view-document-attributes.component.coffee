angular.module('app-factory').directive('afViewDocumentAttributes', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/view-document-attributes.template.html'
	scope:
		'document': 		'='
		'documentSchema': 	'='
	link: ($scope, $element) ->

		$scope.initializeAttributes = ->
			$scope.documentSchema['attributes'].forEach (attribute, index) ->
				name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
				childTemplate = "
					<div class='attribute row'>
						<label ng-bind='documentSchema.attributes[#{index}].name' class='col-lg-4'></label>
						<af-attribute-#{name}-value
							class='col-lg-8'
							attribute='documentSchema.attributes[#{index}]'
							document='document'>
						</af-attribute-#{name}-value>
					</div>
				"
				attributesEl = $('.attributes', $element)
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)

		# Initialize
		$scope.initializeAttributes()

])