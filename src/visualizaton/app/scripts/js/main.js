(function() {
  requirejs.config({
    baseUrl: 'scripts/js/',
    waitSeconds: 0
  });

  requirejs(['world/render', 'world/grid', 'agent/link'], function(Render, Grid, Link) {
    $.get('items.txt').success(function(items) {
      var grid, link, render;
      items = items.split(/\n/);
      render = new Render(items);
      render.paintMap();
      grid = new Grid(items);
      grid.generate();
      link = new Link(20, 37);
      render.paintLink(null, link);
      window.link = link;
      $.get('plan.json').then(function(plan) {
        var action, i, _i, _len;
        for (i = _i = 0, _len = plan.length; _i < _len; i = ++_i) {
          action = plan[i];
          setTimeout((function(action) {
            return function() {
              var coords;
              if (action.indexOf('teleport') !== -1) {
                action = action.split(':');
                coords = action[1].split(',');
                return link.teleport(coords[0], coords[1]);
              } else {
                return link[action]();
              }
            };
          })(action), i * 300);
        }
      });
    });
  });

}).call(this);
