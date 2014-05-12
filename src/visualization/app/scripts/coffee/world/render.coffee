define ['world/map'], (Map) ->
    class Render
        constructor: (items) ->
            @map = Map
            @items = items

        paintMap: =>
            for row, y in @map
                for col, x in row
                    @getPoint(x, y).addClass(col)
                    if col is 'g'
                        @getPoint(x, y).append('<div class="fog"></div>')


            for item in @items
                currentItem = item.split('\ ')
                y = currentItem[0]
                x = currentItem[1]
                itemType = (new String(currentItem[2])).toLowerCase()
                elem = '<div class="'+itemType[0]+'"></div>'
                @getPoint(x, y).append(elem)

        paintLink: (oldLink, newLink) =>
            if oldLink
                @getPoint(oldLink.x, oldLink.y, '.link').remove()

            fog = @getPoint(newLink.x, newLink.y, '.fog')
                .fadeOut('fast', -> $(this).remove())

            elem = '<div class="link link-'+newLink.direction
            elem += ' link-'+newLink.action
            elem += '"></div>'
            @getPoint(newLink.x, newLink.y).append(elem)

        getPoint: (x, y, detail = null) ->
            if detail
                $('.map-lost-woods .map-row-'+y+' .map-col-'+x+' '+detail)
            else
                $('.map-lost-woods .map-row-'+y+' .map-col-'+x)
