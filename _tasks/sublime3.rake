namespace :sublime3 do
  desc "Symlink Sublime Text 3 config"
  task :install do
    sublime_data_dir = "#{ENV["HOME"]}/Library/Application Support/Sublime Text 3"
    if !File.exists?(sublime_data_dir)
      throw "Sublime Data dir ('#{sublime_data_dir}') doesn't exists. Is Sublime Text installed and has been run at least once?"
    end

    sublime_package_dir = "#{sublime_data_dir}/Packages"
    File.mkdir(sublime_package_dir) unless File.exists?(sublime_package_dir)

    Dir['sublime3/Packages/*'].each do |pkg_path|
      source_dir = File.realpath(pkg_path)
      dest_dir = "#{sublime_package_dir}#{pkg_path.gsub(%r{^sublime3/Packages}, '')}"

      if File.exist?(dest_dir)
        if File.realpath(dest_dir) == source_dir
          # puts "'#{dest_dir}' is already pointing to '#{source_dir}'"
        else
          puts "'#{dest_dir}' already exists. Remove it and run `rake` again to relace it"
        end
      else
        puts "symlinking '#{source_dir}' to '#{dest_dir}'"
        File.symlink(source_dir, dest_dir)
      end
    end
  end
end

task :install => 'sublime3:install'