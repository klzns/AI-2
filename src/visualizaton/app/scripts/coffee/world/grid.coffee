define ['world/map', 'world/node'], (Map, Node) ->
    class Grid
        constructor: (items) ->
            @map = Map
            @items = items

        generate: ->
            @grid = []
            for row, y in @map
                currentRow = []
                for col, x in row
                    node = new Node(x, y, col)
                    currentRow.push(node)
                @grid.push(currentRow)

            for item in @items
                continue unless item
                item = item.split('\ ')
                y = item[0]
                x = item[1]
                itemType = (''+item[2]).toLowerCase()
                @grid[x][y].addObject(itemType)

            return

