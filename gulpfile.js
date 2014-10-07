var gulp      = require('gulp'),
  jade        = require('gulp-jade'),
  notify      = require("gulp-notify"),
  sass        = require('gulp-ruby-sass'),
  runSequence = require('run-sequence');

// Global variables
var dist = './www', // Distribution directory
  env = 'dev', // Environment (dev, prod)
  src =  './assets'; // Assets directory
var paths = { //Paths
  styles: { 
    srcdir:  src + '/sass',
    src:   src + '/sass/*.sass',
    dest:  dist + ''
  },
  views: { 
    srcdir:  src + '/views',
    src:   src + '/views/**/*.jade',
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
 * Compile the views
 */
gulp.task('views', function() {
  var YOUR_LOCALS = {}
      , compress_views = env != 'prod' ? true : false; //compress the output if we are in prod

  return gulp.src( paths.views.src )
    .pipe(jade({
      pretty : compress_views
      , locals: YOUR_LOCALS
    }))
    .pipe(gulp.dest( dist+'/' ));
});
/**
 * Watch for changes
 */
gulp.task('watch', function() { 
  gulp.watch(paths.styles.src, ['styles']);
  gulp.watch(paths.views.src, ['views']);
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
    'views',
    callback
  );
  gulp.src('.')
    .pipe(notify({ message: 'Build task complete' }));
});