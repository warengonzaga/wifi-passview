/**
 * Gulpfile for WiFi Passview
 * By Waren Gonzaga
 **/

// gulp packages
const gulp    = require("gulp");
const fs      = require("fs");
const clean   = require("gulp-clean");
const rename  = require("gulp-rename");
const header  = require("gulp-header");

// gulp paths
const path = {
  build: "./prod",
  source: "./src"
};

// white label & copyright label
const whtlbl = JSON.parse(fs.readFileSync(path.source+'/config.json'));
const pkg = JSON.parse(fs.readFileSync('package.json'));
const whtlbldata = {
  whtlblbanner: [
    'cls',
    '@echo off',
    'REM =============================',
    'REM Setup Variables',
    'REM =============================',
    'set appname=<%= title %>',
    'set appvers=<%= version %>',
    'set appstat=<%= status %>',
    'set dev=<%= dev %>',
    'set desc=<%= description %>',
    'set uicolor=<%= uicolor %>',
    'set infouicolor=<%= infouicolor %>',
    'set erruicolor=<%= erruicolor %>',
    'set cliN=$%appname%\n',
  ].join('\n'),
};
const copydata = {
  copybanner: [
    'REM =============================',
    'REM WiFi Passview - <%= homepage %>',
    'REM <%= description %>',
    'REM Version: <%= version %>',
    'REM Github: <%= github %>',
    'REM Licensed Under The MIT License: http://opensource.org/licenses/MIT',
    'REM Copyright (c) <%= new Date().getFullYear() %> <%= author %>',
    'REM ',
    'REM Facebook: @warengonzagaofficialpage',
    'REM Twitter: @warengonzaga',
    'REM Github: @warengonzaga',
    'REM Website: warengonzaga.com',
    'REM ',
    'REM Donate or Support!',
    'REM https://buymeacoff.ee/warengonzaga',
    'REM =============================\n\n',
  ].join('\n'),
};

/**
 * Gulp Tasks
 * Writen by Waren Gonzaga
 */

// add white label
function whitelabel() {
  return gulp
    .src([path.source+'/core.bat'], {allowEmpty: true})
    .pipe(header(whtlbldata.whtlblbanner, whtlbl))
    .pipe(gulp.dest([path.build]));
}

// add copyright label
function copyright() {
  return gulp
    .src([path.build+'/core.bat'], {allowEmpty: true})
    .pipe(header(copydata.copybanner, pkg))
    .pipe(rename(whtlbl.filename+'-'+whtlbl.version+'.bat'))
    .pipe(gulp.dest([path.build]));
}

// delete temporary build
function delcore() {
  return gulp
    .src(path.build+'/core.bat', {read: false})
    .pipe(clean());
}

// copy build to root
function copytoroot() {
  return gulp
    .src(path.build+'/*.bat')
    .pipe(gulp.dest('./'));
}

// clean production folder
function cleanprod() {
  return gulp
    .src('./prod')
    .pipe(clean());
}

// clean existing builds
function cleanroot() {
  return gulp
    .src('./*.bat')
    .pipe(clean());
}

// gulp series
const build = gulp.series([whitelabel, copyright, delcore, copytoroot]);
const cleandev = gulp.series([cleanprod, cleanroot]);

// gulp commands
exports.whitelabel = whitelabel;
exports.copyright = copyright;
exports.delcore = delcore;
exports.copytoroot = copytoroot;
exports.cleanprod = cleanprod;
exports.cleanroot = cleanroot;
exports.cleandev = cleandev;
exports.build = build;
exports.default = build;