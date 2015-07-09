angular.module('app-factory').factory 'PreviewHtmlModal', ->
	return (html, size) ->
		templateUrl: 'client/modals/preview-html-modal.template.html'
		controller: 'PreviewHtmlModalCtrl'
		size: size or 'md'
		resolve:
			'html': -> html

angular.module('app-factory').controller('PreviewHtmlModalCtrl', ['$scope', '$modalInstance', 'html', ($scope, $modalInstance, html) ->

	$scope.html = html

])