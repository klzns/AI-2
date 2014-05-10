requirejs.config
    baseUrl: 'scripts/js/'


# Main function
requirejs ['world/render', 'world/grid'], (Render, Grid) ->
    render = new Render()
    grid = new Grid()
