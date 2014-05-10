define ['world/render'], (Render) ->
    class Link
        constructor: (x, y) ->
            @x = x
            @y = y
            @direction = 'down'
            @render = new Render()

        turnLeft: () =>
            oldLink = @getOldLink()

            if @direction is 'up'
                @direction = 'left'
            else if @direction is 'left'
                @direction = 'down'
            else if @direction is 'down'
                @direction = 'right'
            else if @direction is 'right'
                @direction = 'up'

            @render.paintLink(oldLink, @)

        turnRight: () =>
            oldLink = @getOldLink()

            if @direction is 'up'
                @direction = 'right'
            else if @direction is 'right'
                @direction = 'down'
            else if @direction is 'down'
                @direction = 'left'
            else if @direction is 'left'
                @direction = 'up'

            @render.paintLink(oldLink, @)

        moveForward: () =>
            oldLink = @getOldLink()

            if @direction is 'up'
                @y = @y - 1
            else if @direction is 'right'
                @x = @x + 1
            else if @direction is 'down'
                @y = @y + 1
            else if @direction is 'left'
                @x = @x - 1

            @render.paintLink(oldLink, @)

        getOldLink: () =>
            oldLink =
                x: @x
                y: @y
                direction: @direction



