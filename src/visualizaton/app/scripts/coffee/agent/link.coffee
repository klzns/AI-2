define ['world/render'], (Render) ->
    class Link
        constructor: (x, y) ->
            @x = x
            @y = y
            @direction = 'down'
            @action = ''
            @energy = 100
            @render = new Render()

        turnLeft: () =>
            @action = ''
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
            @action = ''
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
            @action = ''
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

        attack: () =>
            oldLink = @getOldLink()

            @action = 'attacking'
            @render.paintLink(oldLink, @)

        getRupee: () =>
            oldLink = @getOldLink()

            @action = 'get-rupee'
            @render.paintLink(oldLink, @)

        getSword: () =>
            oldLink = @getOldLink()

            @action = 'get-sword'
            @render.paintLink(oldLink, @)

        getHeart: () =>
            oldLink = @getOldLink()

            @action = 'get-heart'
            @render.paintLink(oldLink, @)

        inHole: () =>
            oldLink = @getOldLink()

            @action = 'falling'
            @render.paintLink(oldLink, @)

        inVortex: () =>
            oldLink = @getOldLink()

            @action = 'vortex'
            @render.paintLink(oldLink, @)

        beingAttacked: () =>
            oldLink = @getOldLink()

            @action = 'damage'
            @render.paintLink(oldLink, @)

        know: (x, y) =>
            @render.getPoint(x, y, 'div').addClass('know')

        changeEnergy: (to) ->
            if to <= 0
                $('.heart-1, .heart-2, .heart-3')
                    .removeClass('heart-full')
                    .addClass('heart-empty')
            else if to < 33
                $('.heart-1')
                    .removeClass('heart-empty')
                    .addClass('heart-full')
                $('.heart-2, .heart-3')
                    .removeClass('heart-full')
                    .addClass('heart-empty')
            else if to < 66
                $('.heart-1, .heart-2')
                    .removeClass('heart-empty')
                    .addClass('heart-full')
                $('.heart-3')
                    .removeClass('heart-full')
                    .addClass('heart-empty')
            else
                $('.heart-1, .heart-2, .heart-3')
                    .removeClass('heart-empty')
                    .addClass('heart-full')

            $('.energy').text(to)

        getOldLink: () =>
            oldLink =
                x: @x
                y: @y
                direction: @direction



