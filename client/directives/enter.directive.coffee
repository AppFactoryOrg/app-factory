angular.module('app-factory').directive('afEnter', ->
	link: (scope, element, attrs) ->
		element.bind('keydown keypress', (event) ->
			if event.which == 13
				scope.$apply( ->
					scope.$eval(attrs.afEnter)
				)
				event.preventDefault()
		)
)
