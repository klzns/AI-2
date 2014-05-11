define ['world/render'], (Render) ->
    class Link
        constructor: (x, y) ->
            @x = x
            @y = y
            @direction = 'down'
            @action = ''
            @cost = 0
            @energy = 100
            @render = new Render()

        turnLeft: () =>
            @changeCost(@cost-1)
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
            @changeCost(@cost-1)
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
            @changeCost(@cost-1)
            @action = ''
            oldLink = @getOldLink()

            [@x, @y] = @getPointForward()

            @render.paintLink(oldLink, @)

        attack: () =>
            oldLink = @getOldLink()

            [x, y] = @getPointForward()
            isMonsterThere = @render.getPoint(x, y, '.e')
            if isMonsterThere[0]
                $(isMonsterThere[0]).fadeOut('slow', -> $(this).remove())
                @changeEnergy(@energy-10)

            @action = 'attack'
            @render.paintLink(oldLink, @)

        getRupee: () =>
            @action = ''
            @changeCost(@cost+10)
            oldLink = @getOldLink()

            @removeObject(@x, @y, '.r')

            @action = 'get-rupee'
            @render.paintLink(oldLink, @)

        getSword: () =>
            @action = ''
            @changeCost(@cost-100)
            oldLink = @getOldLink()

            @removeObject(@x, @y, '.m')

            @action = 'get-sword'
            @render.paintLink(oldLink, @)

        getFakeSword: () =>
            @action = ''
            @changeCost(@cost-100)
            oldLink = @getOldLink()

            @removeObject(@x, @y, '.f')

            @action = 'get-sword'
            @render.paintLink(oldLink, @)

        getHeart: () =>
            @action = ''
            @changeCost(@cost-10)
            @changeEnergy(@energy+50)
            oldLink = @getOldLink()

            @removeObject(@x, @y, '.c')

            @action = 'get-heart'
            @render.paintLink(oldLink, @)

        fallDownHole: () =>
            @changeCost(@cost-10000)
            oldLink = @getOldLink()

            @action = 'falling'
            @render.paintLink(oldLink, @)

        goIntoVortex: () =>
            @action = ''
            oldLink = @getOldLink()

            @action = 'vortex'
            @render.paintLink(oldLink, @)

        getAttacked: () =>
            @action = ''
            @changeCost(@cost-10000)
            oldLink = @getOldLink()

            @action = 'damage'
            @render.paintLink(oldLink, @)

        teleport: (x, y) =>
            @action = ''
            oldLink = @getOldLink()
            @action = ''
            [@x, @y] = [x, y]

            @render.paintLink(oldLink, @)

        know: (x, y) =>
            @render.getPoint(x, y, 'div').addClass('know')

        removeObject: (x, y, object) =>
            object = @render.getPoint(x, y, object)
            if object[0]
                $(object[0]).remove()
                return true
            return false

        changeCost: (to) =>
            $('.cost').text(to)
            @cost = to

        changeEnergy: (to) =>
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
            @energy = to

        getPointForward: () =>
            [x, y] = [@x, @y]

            if @direction is 'up'
                y = parseInt(y) - 1
            else if @direction is 'right'
                x = parseInt(x) + 1
            else if @direction is 'down'
                y = parseInt(y) + 1
            else if @direction is 'left'
                x = parseInt(x) - 1

            return [x, y]

        getOldLink: () =>
            oldLink =
                x: @x
                y: @y
                direction: @direction
