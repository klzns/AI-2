define ['world/map'], (Map) ->
    class Render
        constructor: () ->
            @map = Map

            @paint()

        paint: =>
            for row, x in @map
                for col, y in row
                    @getPoint(x, y).addClass(col)


        getPoint: (x, y) ->
            $('.map-lost-woods .map-row-'+x+' .map-col-'+y)
