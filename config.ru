$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/lib')
require "fives_controller"

$saturday_date = '25'
$sunday_date = '26'
$year = '2013'
$season = '2012/13'
run FivesController

