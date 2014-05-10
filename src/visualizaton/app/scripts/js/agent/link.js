(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['world/render'], function(Render) {
    var Link;
    return Link = (function() {
      function Link(x, y) {
        this.getOldLink = __bind(this.getOldLink, this);
        this.moveForward = __bind(this.moveForward, this);
        this.turnRight = __bind(this.turnRight, this);
        this.turnLeft = __bind(this.turnLeft, this);
        this.x = x;
        this.y = y;
        this.direction = 'down';
        this.render = new Render();
      }

      Link.prototype.turnLeft = function() {
        var oldLink;
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.direction = 'left';
        } else if (this.direction === 'left') {
          this.direction = 'down';
        } else if (this.direction === 'down') {
          this.direction = 'right';
        } else if (this.direction === 'right') {
          this.direction = 'up';
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.turnRight = function() {
        var oldLink;
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.direction = 'right';
        } else if (this.direction === 'right') {
          this.direction = 'down';
        } else if (this.direction === 'down') {
          this.direction = 'left';
        } else if (this.direction === 'left') {
          this.direction = 'up';
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.moveForward = function() {
        var oldLink;
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.y = this.y - 1;
        } else if (this.direction === 'right') {
          this.x = this.x + 1;
        } else if (this.direction === 'down') {
          this.y = this.y + 1;
        } else if (this.direction === 'left') {
          this.x = this.x - 1;
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getOldLink = function() {
        var oldLink;
        return oldLink = {
          x: this.x,
          y: this.y,
          direction: this.direction
        };
      };

      return Link;

    })();
  });

}).call(this);
