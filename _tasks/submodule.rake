desc "Initialize submodules"
task :submodules do
  puts "Initialize and update submodules"
  system 'git', 'submodule', 'init'
  system 'git', 'submodule', 'update'
end