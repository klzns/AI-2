'use strict';
// generated on 2014-05-09 using generator-gulp-webapp 0.1.0

var gulp = require('gulp');

// load plugins
var $ = require('gulp-load-plugins')();

gulp.task('desktop', [], function () {
    var connect = require('connect');
    var app = connect()
        .use(connect.static('app'))
        .use(connect.static('.tmp'))
        .use(connect.directory('app'));

    require('http').createServer(app)
        .listen(9000)
        .on('listening', function () {
            console.log('Started connect web server on http://localhost:9000');
        });
    require('opn')('http://localhost:9000');
});

gulp.run('desktop');
