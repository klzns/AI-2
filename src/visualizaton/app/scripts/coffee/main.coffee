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
        $.get('plan.json').then (plan) ->
            link.doPlan(plan)
            return
        return
    return
