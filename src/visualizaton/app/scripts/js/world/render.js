(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['world/map'], function(Map) {
    var Render;
    return Render = (function() {
      function Render(items) {
        this.paintLink = __bind(this.paintLink, this);
        this.paintMap = __bind(this.paintMap, this);
        this.map = Map;
        this.items = items;
      }

      Render.prototype.paintMap = function() {
        var col, currentItem, elem, item, itemType, row, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _results;
        _ref = this.map;
        for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
          row = _ref[y];
          for (x = _j = 0, _len1 = row.length; _j < _len1; x = ++_j) {
            col = row[x];
            this.getPoint(x, y).addClass(col);
          }
        }
        _ref1 = this.items;
        _results = [];
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          item = _ref1[_k];
          currentItem = item.split('\ ');
          y = currentItem[0];
          x = currentItem[1];
          itemType = (new String(currentItem[2])).toLowerCase();
          elem = '<div class="' + itemType[0] + '"></div>';
          _results.push(this.getPoint(x, y).append(elem));
        }
        return _results;
      };

      Render.prototype.paintLink = function(oldLink, newLink) {
        var elem;
        if (oldLink) {
          this.getPoint(oldLink.x, oldLink.y, true).remove();
        }
        elem = '<div class="link link-' + newLink.direction + '"></div>';
        return this.getPoint(newLink.x, newLink.y).append(elem);
      };

      Render.prototype.getPoint = function(x, y, link) {
        if (link == null) {
          link = null;
        }
        if (link) {
          return $('.map-lost-woods .map-row-' + y + ' .map-col-' + x + ' .link');
        } else {
          return $('.map-lost-woods .map-row-' + y + ' .map-col-' + x);
        }
      };

      return Render;

    })();
  });

}).call(this);
