require_relative 'middleware/app_logger'
require_relative 'middleware/runtime'
require_relative 'app'

use AppLogger
use Runtime

run App.new
