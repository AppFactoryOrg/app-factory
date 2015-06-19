angular.module('app-factory').directive('afServiceValueConfiguration', ['$compile', '$meteor', '$timeout', ($compile, $meteor, $timeout) ->
	restrict: 'E'
	templateUrl: 'client/components/services/value/service-value-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
		$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find()

		$scope.showDocumentSelection =  ->
			return unless $scope.service?
			switch $scope.service['configuration']['data_type']
				when DocumentAttribute.DATA_TYPE['Document'].value
					return true
				when DocumentAttribute.DATA_TYPE['Collection'].value
					return true
				else
					return false
			
			return false

		$scope.showValue =  ->
			return false unless $scope.service?
			return false unless $scope.service['configuration']['data_type']?

			switch $scope.service['configuration']['data_type']
				when DocumentAttribute.DATA_TYPE['Document'].value
					return $scope.service['configuration']['document_schema_id']?
				when DocumentAttribute.DATA_TYPE['Collection'].value
					return $scope.service['configuration']['document_schema_id']?
				else
					return true
			
			return false

		$scope.setupValueInput = -> $timeout ->
			if $scope.showValue()
				type = $scope.service['configuration']['data_type']
				name = _.findWhere(DocumentAttribute.DATA_TYPE, value: type).component
				childTemplate = "
					<af-attribute-#{name}-input 
						key='\"value\"'
						object='service.configuration'
						name='service.configuration.name'
						config='service.configuration'>
					</af-attribute-#{name}-input >
				"
				attributesEl = $('.service-value', $element)
				attributesEl.empty()
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)
			else
				$('.service-value', $element).empty()

		# Initialize
		$scope.setupValueInput()

		$scope.$watch 'service.configuration', (newConfig, oldConfig) ->
			return unless newConfig? and oldConfig?

			data_type_changed = newConfig['data_type'] isnt oldConfig['data_type']
			document_type_changed = newConfig['document_schema_id'] isnt oldConfig['document_schema_id']
			
			if data_type_changed or document_type_changed
				newConfig['value'] = null

				unless $scope.showDocumentSelection()
					newConfig['document_schema_id'] = null

				$scope.setupValueInput()
		, true
])