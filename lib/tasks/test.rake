# From http://www.neeraj.name/blog/articles/679-rake-tasks-for-testing-lib-helper-and-all

namespace :test do
  Rake::TestTask.new(:libs => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/lib/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:libs'].comment = "Run the tests in test/lib"

  Rake::TestTask.new(:helpers => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/helpers/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:helpers'].comment = "Run the tests in test/helpers"
end

desc 'Run all unit,lib, functional and integration tests'
task :test do
  errors = %w(test:libs test:units test:functionals test:integration).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end
