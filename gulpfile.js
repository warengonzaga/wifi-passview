/**
 * Gulpfile for WiFi Passview
 * By Waren Gonzaga
 **/

//Dependencies
var fs = require('fs');
var gulp = require('gulp');
var gutil = require('gulp-util');
var clean = require('gulp-clean');

var path = {
    "prod":"./prod/",
    "config":"./src/config.json",
    "core":"./src/core.json"
    },
    
    //Get the data from json files
    $config = JSON.parse(fs.readFileSync(path.config)),
    $core = JSON.parse(fs.readFileSync(path.core));
    
//Core Tasks Don't Edit
gulp.task('build', function(cb){
  fs.writeFile(path.prod+$config.config.filename+'_'+$config.config.version+'.bat', $core.codes01+$config.config.title+" "+$config.config.version+" "+$core.codes02+" "+$config.config.author+$core.codes03+$config.config.facebook+$core.codes04+$config.config.twitter+$core.codes05+$config.config.github+$core.codes06+$config.config.email+$core.codes07+$config.config.facebook+$core.codes08, cb);
});


//Clean Task
gulp.task('clean', function() {
   return gulp.src(path.prod+$config.config.filename+'_'+$config.config.version+'.bat', {read: false})
        .pipe(clean()); 
});
	
//Default Tasks
gulp.task('default', ['build']);