requirejs.config
    baseUrl: 'scripts/js/'

# Main function
requirejs ['world/render', 'agent/link'], (Render, Link) ->
    $.get('items.txt').success (items) ->
        items = items.split(/\n/)
        render = new Render(items)
        render.paintMap()
        link = new Link(20, 37)
        render.paintLink(null, link)
        window.link = link
        $.get('action-log.json').then (plan) ->
            link.doPlan(plan)
            return
        return
    return
