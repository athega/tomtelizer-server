namespace :test do
   desc "libs tests"
   task :lib => :environment do
      Rake::TestTask.new(:lib) do |t|

        puts "running lib tests"

        t.libs << 'test'
        files = FileList['test/lib/*_test.rb']

        t.test_files = files
        t.verbose = true

      end

      Rake::Task[:lib].invoke
   end
end
Rake::Task[:test].enhance(['test:lib'])