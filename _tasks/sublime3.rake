namespace :sublime3 do
  sublime_data_dir = "#{ENV["HOME"]}/Library/Application Support/Sublime Text 3"
  sublime_package_dir = "#{sublime_data_dir}/Packages"

  task :ensure_data_dir do
    if !File.exists?(sublime_data_dir)
      throw "Sublime Data dir ('#{sublime_data_dir}') doesn't exists. Is Sublime Text installed and has been run at least once?"
    end
  end

  desc "Symlink Sublime Text 3 config"
  task :install => :ensure_data_dir do
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

  desc "Clean dead symlinks in Sublime Text 3 config folder"
  task :clean => :ensure_data_dir do
    Dir["#{sublime_package_dir}/*"].each do |pkg|
      if File.symlink?(pkg) 
        link_target = File.readlink(pkg)
        if !File.exist?(link_target)
          is_clean = false
          print "'#{pkg}' is dead symlink to '#{link_target}' delete (y/N)? "
          if STDIN.gets.chomp.downcase == 'y'
            puts "deleting #{pkg}"
            File.unlink(pkg)
          end
        end
      end
    end
  end
end

task :install => 'sublime3:install'