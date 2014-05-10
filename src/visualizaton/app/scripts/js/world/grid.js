(function() {
  define(['world/map', 'world/node'], function(Map, Node) {
    var Grid;
    return Grid = (function() {
      function Grid(items) {
        this.map = Map;
        this.items = items;
      }

      Grid.prototype.generate = function() {
        var col, currentRow, item, itemType, node, row, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
        this.grid = [];
        _ref = this.map;
        for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
          row = _ref[y];
          currentRow = [];
          for (x = _j = 0, _len1 = row.length; _j < _len1; x = ++_j) {
            col = row[x];
            node = new Node(x, y, col);
            currentRow.push(node);
          }
          this.grid.push(currentRow);
        }
        _ref1 = this.items;
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          item = _ref1[_k];
          if (!item) {
            continue;
          }
          item = item.split('\ ');
          y = item[0];
          x = item[1];
          itemType = ('' + item[2]).toLowerCase();
          this.grid[x][y].addObject(itemType);
        }
      };

      return Grid;

    })();
  });

}).call(this);
