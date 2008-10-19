require File.dirname(__FILE__) + '/support/tasks'
Dir[File.join(File.dirname(__FILE__), %w[.. .. tasks], '**/*.rake')].each { |rake| load rake }