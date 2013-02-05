require 'rake'

Dir[File.expand_path('../_tasks/*.rake', __FILE__)].each do |tasks|
  load tasks
end

desc "Hook our dotfiles into system-standard positions."
task :install => [:install_sublime3] do
  linkables = Dir.glob('**/*.symlink')

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then skip = true
        end
      end
      next if skip || skip_all
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    puts "linking #{ENV["PWD"]}/#{linkable} to #{target}"
    `ln -s "$PWD/#{linkable}" "#{target}"`
  end
end

desc "Symlink Sublime Text 3 config"
task :install_sublime3 do
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

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end
    
    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

desc "Do everything that can be safely run after pulls"
task :default => 'install'

desc "Do everything"
task :all => 'default'
