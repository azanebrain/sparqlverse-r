var gulp      = require('gulp'),
  notify      = require("gulp-notify"),
  runSequence = require('run-sequence'),
  sass        = require('gulp-ruby-sass');

// Global variables
var dist = './www', // Distribution directory
  env = 'dev', // Environment (dev, prod)
  src =  './assets'; // Assets directory
var paths = { //Paths
  styles: { 
    srcdir:  src + '/sass',
    src:   src + '/sass/*.sass',
    dest:  dist + ''
  }
};

/**
 * Set the environment
 */
gulp.task('set-environment', function() {
  env = 'prod';
});

/**
 * Compile the styles for the app
 */
gulp.task('styles', function(callback) {
  // Set the environment-dependent variables
  var sourcemap = true,
    style = "nested";

  if ( env == 'prod' ){
    sourcemap = false;
    style = "compressed";
  }

  return gulp.src( paths.styles.src )
    .pipe(sass({
      sourcemap: sourcemap, 
      sourcemapPath: paths.styles.dest,
      style: style
    }))
    .on('error', function (err) { console.log(err.message); })
    .pipe(gulp.dest( paths.styles.dest ));
});

/**
 * Watch for changes
 */
gulp.task('watch', function() { 
  gulp.watch(paths.styles.src, ['styles']);
});

// The default task is watch
gulp.task('default', [
  'watch'
]);

/**
 * Build the app for production
 */
gulp.task('build', function(callback) {
  runSequence(
    'set-environment',
    'styles',
    callback
  );
  gulp.src('.')
    .pipe(notify({ message: 'Build task complete' }));
});