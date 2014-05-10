(function() {
  requirejs.config({
    baseUrl: 'scripts/js/',
    waitSeconds: 0
  });

  requirejs(['world/render', 'world/grid', 'agent/link'], function(Render, Grid, Link) {
    return $.get('items.txt').success(function(items) {
      var grid, link, render;
      items = items.split(/\n/);
      items = items.slice(0);
      render = new Render(items);
      render.paintMap();
      grid = new Grid(items);
      grid.generate();
      link = new Link(20, 37);
      render.paintLink(null, link);
      return window.link = link;
    });
  });

}).call(this);
