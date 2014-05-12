define ->
    class Node
        constructor: (x, y, terrain) ->
            @x = x
            @y = y
            @terrain = terrain
            @objects = []

        addObject: (object) ->
            @objects.push(object)
