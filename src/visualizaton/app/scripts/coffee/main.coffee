requirejs.config
    baseUrl: 'scripts/js/'
    waitSeconds: 0


# Main function
requirejs ['world/render', 'world/grid', 'agent/link'], (Render, Grid, Link) ->
    $.get('items.txt').success (items) ->
        items = items.split(/\n/)
        render = new Render(items)
        render.paintMap()
        grid = new Grid(items)
        grid.generate()
        link = new Link(20, 37)
        render.paintLink(null, link)
        window.link = link
        $.get('plan.json')
            .then (plan) ->
                for action, i in plan
                    setTimeout do (action) ->
                        ->
                            if action.indexOf('teleport') isnt -1
                                action = action.split(':')
                                coords = action[1].split(',')
                                link.teleport(coords[0], coords[1])
                            else
                                link[action]()
                    , (i*300)

                return

        return

    return
