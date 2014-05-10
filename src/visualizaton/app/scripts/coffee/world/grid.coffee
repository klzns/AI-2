define ['world/map'], (Map) ->
    class Grid
        constructor: () ->
            @map = Map

            @grid = []

            @generate()

        generate: ->

