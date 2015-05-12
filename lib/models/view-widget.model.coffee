@ViewWidget =

	TYPE:
		'Container':		{value: 100,	icon: 'fa-th-large'}
		'Table':			{value: 150,	icon: 'fa-table'}
		'List':				{value: 200,	icon: 'fa-th-list'}
		'Content':			{value: 250,	icon: 'fa-paragraph'}
		'View':				{value: 300,	icon: 'fa-list-alt'}
		'Button':			{value: 350,	icon: 'fa-caret-square-o-right'}


	new: ->
		'id':				null
		'name':				null
		'type':				null
		'configuration':	{}
		'parent_id':		null
