angular.module('app-factory').factory('RoutineUtils', ['$meteor', '$q', ($meteor, $q) ->
	endpointStyles:
		'outflow':
			endpoint: 'Dot'
			isSource: true
			scope: 'execution'
			paintStyle:
				fillStyle: '#5bc0de'
				strokeStyle: '#A9DCEB'
				lineWidth: 2
				radius: 5
			connector: [
				'Flowchart'
				{
					stub: [
						10
						10
					]
					gap: 11
					cornerRadius: 5
					alwaysRespectStubs: true
				}
			]
			connectorStyle:
				lineWidth: 2
				strokeStyle: '#5bc0de'
				joinstyle: 'round'
			hoverPaintStyle:
				fillStyle: '#A9DCEB'
				strokeStyle: '#A9DCEB'
			connectorHoverStyle:
				lineWidth: 4
				strokeStyle: '#5bc0de'
			dragOptions: {}

		'inflow':
			endpoint: 'Dot'
			isTarget: true
			scope: 'execution'
			paintStyle:
				fillStyle: '#5bc0de'
				strokeStyle: '#A9DCEB'
				radius: 5
				lineWidth: 2
			hoverPaintStyle:
				fillStyle: '#A9DCEB'
				strokeStyle: '#A9DCEB'
			maxConnections: 1
			dropOptions:
				hoverClass: 'hover'
				activeClass: 'active'

		'output':
			endpoint: 'Dot'
			isSource: true
			scope: 'information'
			maxConnections: -1
			paintStyle:
				fillStyle: '#837a9f'
				strokeStyle: '#a7a1ba'
				lineWidth: 2
				radius: 5
			connector: [
				'Flowchart'
				{
					stub: [
						10
						10
					]
					gap: 8
					cornerRadius: 5
					alwaysRespectStubs: true
				}
			]
			connectorStyle:
				lineWidth: 2
				strokeStyle: '#a7a1ba'
				joinstyle: 'round'
			hoverPaintStyle:
				fillStyle: '#a7a1ba'
				strokeStyle: '#a7a1ba'
			connectorHoverStyle:
				lineWidth: 4
				strokeStyle: '#a7a1ba'
			dragOptions: {}

		'input':
			endpoint: 'Dot'
			isTarget: true
			scope: 'information'
			paintStyle:
				fillStyle: '#837a9f'
				strokeStyle: '#a7a1ba'
				radius: 5
				lineWidth: 2
			hoverPaintStyle:
				fillStyle: '#a7a1ba'
				strokeStyle: '#a7a1ba'
			dropOptions:
				hoverClass: 'hover'
				activeClass: 'active'

		'input-multiple':
			endpoint: 'Dot'
			isTarget: true
			scope: 'information'
			maxConnections: -1
			paintStyle:
				fillStyle: '#837a9f'
				strokeStyle: '#a7a1ba'
				radius: 5
				lineWidth: 2
			hoverPaintStyle:
				fillStyle: '#a7a1ba'
				strokeStyle: '#a7a1ba'
			dropOptions:
				hoverClass: 'hover'
				activeClass: 'active'

		'error':
			endpoint: 'Dot'
			isSource: true
			scope: 'execution'
			paintStyle:
				fillStyle: '#df706c'
				strokeStyle: '#eaa8a7'
				lineWidth: 2
				radius: 5
			connector: [
				'Flowchart'
				{
					stub: [
						10
						10
					]
					gap: 11
					cornerRadius: 5
					alwaysRespectStubs: true
				}
			]
			connectorStyle:
				lineWidth: 2
				strokeStyle: '#5bc0de'
				joinstyle: 'round'
			hoverPaintStyle:
				fillStyle: '#A9DCEB'
				strokeStyle: '#A9DCEB'
			connectorHoverStyle:
				lineWidth: 4
				strokeStyle: '#5bc0de'
			dragOptions: {}

		'success':
			endpoint: 'Dot'
			isSource: true
			scope: 'execution'
			paintStyle:
				fillStyle: '#7ac67a'
				strokeStyle: '#aedbaf'
				lineWidth: 2
				radius: 5
			connector: [
				'Flowchart'
				{
					stub: [
						10
						10
					]
					gap: 11
					cornerRadius: 5
					alwaysRespectStubs: true
				}
			]
			connectorStyle:
				lineWidth: 2
				strokeStyle: '#5bc0de'
				joinstyle: 'round'
			hoverPaintStyle:
				fillStyle: '#A9DCEB'
				strokeStyle: '#A9DCEB'
			connectorHoverStyle:
				lineWidth: 4
				strokeStyle: '#5bc0de'
			dragOptions: {}

	getEndpointStyleForNode: (node) ->
		if node['style']?
			key = node['style']
		else
			key = node['type']
		return @endpointStyles[key]
])
