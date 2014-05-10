define ['world/map'], (Map) ->
    class Render
        constructor: (items) ->
            @map = Map
            @items = items

        paintMap: =>
            for row, y in @map
                for col, x in row
                    @getPoint(x, y).addClass(col)

            for item in @items
                currentItem = item.split('\ ')
                y = currentItem[0]
                x = currentItem[1]
                itemType = (new String(currentItem[2])).toLowerCase()
                elem = '<div class="'+itemType[0]+'"></div>'
                @getPoint(x, y).append(elem)

        paintLink: (oldLink, newLink) =>
            if oldLink
                @getPoint(oldLink.x, oldLink.y, true).remove()

            elem = '<div class="link link-'+newLink.direction+'"></div>'
            @getPoint(newLink.x, newLink.y).append(elem)

        getPoint: (x, y, link = null) ->
            if link
                return $('.map-lost-woods .map-row-'+y+' .map-col-'+x+' .link')
            else
                return $('.map-lost-woods .map-row-'+y+' .map-col-'+x)
