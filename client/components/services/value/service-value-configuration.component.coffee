angular.module('app-factory').directive('afServiceValueConfiguration', ['$compile', '$meteor', '$timeout', ($compile, $meteor, $timeout) ->
	restrict: 'E'
	templateUrl: 'client/components/services/value/service-value-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = _.reject(Utils.mapToArray(DocumentAttribute.DATA_TYPE), (type) -> type['data_dependent'] is true)
		$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find()
		$scope.configuration = null
		$scope.selectedDataType = null
		$scope.selectedDocumentSchema = null
		$scope.selectedAttribute = null
		$scope.attributes = []

		$scope.loadAttributes = ->
			if $scope.selectedDocumentSchema?
				$scope.attributes = _.filter($scope.selectedDocumentSchema.attributes, {'data_type': $scope.service['configuration']['data_type']})
			else
				$scope.attributes = []

		$scope.showValue =  ->
			return false unless $scope.service?
			return false unless $scope.service['configuration']['data_type']?
			return false unless $scope.selectedDataType?

			type = $scope.service['configuration']['data_type']
			if type is DocumentAttribute.DATA_TYPE['Option'].value
				return false unless $scope.service['configuration']['document_schema_id']?
				return false unless $scope.service['configuration']['attribute_id']?
				return false unless $scope.selectedDocumentSchema?
				return false unless $scope.selectedAttribute?

			return true

		$scope.showDocumentTypeSelection = ->
			type = $scope.service['configuration']['data_type']
			return true if type is DocumentAttribute.DATA_TYPE['Option'].value
			return false

		$scope.showAttributeSelection = ->
			type = $scope.service['configuration']['data_type']
			if type is DocumentAttribute.DATA_TYPE['Option'].value
				return true if $scope.service['configuration']['document_schema_id']?

			return false

		$scope.dataTypeChanged = ->
			$scope.service['configuration']['data_type'] = $scope.selectedDataType
			$scope.service['configuration']['value'] = null
			$scope.service['configuration']['document_schema_id'] = null
			$scope.service['configuration']['attribute_id'] = null

			$scope.selectedDocumentSchema = null
			$scope.selectedAttribute = null
			$scope.attributes = []

			$scope.setupValueInput()

		$scope.documentTypeChanged = ->
			document_schema_id = $scope.selectedDocumentSchema?['_id']

			$scope.service['configuration']['document_schema_id'] = document_schema_id
			$scope.service['configuration']['attribute_id'] = null

			$scope.selectedAttribute = null

			$scope.loadAttributes()

		$scope.attributeChanged = ->
			attribute_id = $scope.selectedAttribute?['id']

			$scope.service['configuration']['attribute_id'] = attribute_id
			$scope.setupValueInput()

		$scope.setupValueInput = -> $timeout ->
			if $scope.showValue()
				$scope.configuration = angular.copy($scope.service['configuration'])

				if $scope.selectedDataType is DocumentAttribute.DATA_TYPE['Option'].value
					$scope.configuration['options'] = $scope.selectedAttribute['configuration']['options']

				type = $scope.service['configuration']['data_type']
				name = _.findWhere(DocumentAttribute.DATA_TYPE, value: type).component
				childTemplate = "
					<af-attribute-#{name}-input
						key='\"value\"'
						object='service.configuration'
						name='service.configuration.name'
						config='configuration'>
					</af-attribute-#{name}-input >
				"
				attributesEl = $('.service-value', $element)
				attributesEl.empty()
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)
			else
				$('.service-value', $element).empty()

		# Initialize
		$scope.selectedDataType = $scope.service['configuration']['data_type']
		$scope.selectedDocumentSchema = DocumentSchema.db.findOne($scope.service['configuration']['document_schema_id'])
		$scope.loadAttributes()
		$scope.selectedAttribute = _.find($scope.attributes, {'id': $scope.service['configuration']['attribute_id']})
		$scope.setupValueInput()

		# Cleanup when data is invalid
		$scope.service['configuration']['attribute_id'] = null unless $scope.selectedAttribute?
		$scope.service['configuration']['document_schema_id'] = null unless $scope.selectedDocumentSchema?
		$scope.service['configuration']['value'] = null unless $scope.showValue()
])
