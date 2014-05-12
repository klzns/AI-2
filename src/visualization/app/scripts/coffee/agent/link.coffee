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
            oldLink = @getOldLink()
            @changeCost(@cost-1)

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
            @changeCost(@cost-1)

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
            @changeCost(@cost-1)

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
            oldLink = @getOldLink()
            @changeCost(@cost+10)

            @removeObject(@x, @y, '.r')

            @action = 'get-rupee'
            @render.paintLink(oldLink, @)

        getSword: () =>
            oldLink = @getOldLink()
            @changeCost(@cost-100)

            @removeObject(@x, @y, '.m')

            @action = 'get-sword'
            @render.paintLink(oldLink, @)

        getFakeSword: () =>
            oldLink = @getOldLink()
            @changeCost(@cost-100)

            @removeObject(@x, @y, '.f')

            @action = 'get-sword'
            @render.paintLink(oldLink, @)

        getHeart: () =>
            oldLink = @getOldLink()
            @changeCost(@cost-10)

            if @removeObject(@x, @y, '.c')
                @changeEnergy(@energy+50)

            @action = 'get-heart'
            @render.paintLink(oldLink, @)

        fallDownHole: () =>
            oldLink = @getOldLink()
            @changeCost(@cost-10000)

            @changeEnergy(0)

            @action = 'falling'
            @render.paintLink(oldLink, @)

        goIntoVortex: () =>
            oldLink = @getOldLink()

            @action = 'vortex'
            @render.paintLink(oldLink, @)

        getAttacked: () =>
            oldLink = @getOldLink()
            @changeCost(@cost-10000)
            @changeEnergy(0)

            @action = 'damage'
            @render.paintLink(oldLink, @)

        teleport: (x, y) =>
            oldLink = @getOldLink()
            [@x, @y] = [x, y]

            @render.paintLink(oldLink, @)

        know: (x, y) =>
            @render.getPoint(x, y, 'div').addClass('know')

        doPlan: (plan) =>
            for action, i in plan
                setTimeout do (action) =>
                    =>
                        if action.indexOf('teleport') isnt -1
                            action = action.split(':')
                            coords = action[1].split(',')
                            @teleport(coords[0], coords[1])
                        else
                            @[action]()
                , (i*300)

        removeObject: (x, y, object) =>
            object = @render.getPoint(x, y, object)
            if object[0]
                $(object[0]).remove()
                return true
            else
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
            @action = ''
            oldLink =
                x: @x
                y: @y
                direction: @direction
