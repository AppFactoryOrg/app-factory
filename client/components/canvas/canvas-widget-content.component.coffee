angular.module('app-factory').directive('afCanvasWidgetContent', ['$modal', 'GenericModal', 'PreviewHtmlModal', ($modal, GenericModal, PreviewHtmlModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-content.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->
		$scope.configureWidget = ->
			$modal.open(new GenericModal({
				title: 'Configure Content Widget'
				submitAction: 'Save'
				attributes: [
					{
						name: 'content_html'
						displayAs: 'Content'
						type: 'html'
						required: true
						autofocus: true
						default: $scope.widget['configuration']['content_html']
					}
				]
			}, 'lg')).result.then (parameters) ->
				$scope.widget['configuration']['content_html'] = parameters['content_html']

		$scope.previewContent = ->
			content = $scope.widget['configuration']['content_html']
			$modal.open(new PreviewHtmlModal(content, 'lg'))

])