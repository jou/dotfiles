require 'rake'
require 'pathname'

Dir[File.expand_path('../_tasks/*.rake', __FILE__)].each do |tasks|
  load tasks
end

def unsplat(&p)
  proc {|args| p.call(*args) }
end

def link_candidates(&absolutize)
  home = Pathname.new ENV["HOME"]
  absolutize = proc {|path| Pathname.pwd+path}

  file_links = Pathname.glob('**/*.symlink')
    .map(&absolutize)
    .map { |source_file|
      dot_name = home+".#{source_file.basename('.symlink')}"
      [source_file, dot_name]
    }

  file_links += Pathname.glob('**/*.symlink-contents')
    .map(&absolutize)
    .flat_map { |source_folder|
      dot_folder = home+".#{source_folder.basename('.symlink-contents')}"

      Dir.chdir source_folder do 
        Pathname.glob('*')
          .map {|source|
            source_file = source_folder + source
            destination_file = dot_folder + source

            [source_file, destination_file]
          }
      end
    }

  return file_links
end

desc "Hook our dotfiles into system-standard positions."
task :install do
  skip_all = false
  overwrite_all = false
  backup_all = false

  dotfiles = Pathname.pwd
  home = Pathname.new ENV["HOME"]

  link = proc do |source, target|
    overwrite = false
    backup = false

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
      `mv "#{target}" "#{target}.backup"` if backup || backup_all
    end
    puts "linking #{source} to #{target}"
    `ln -s "#{source}" "#{target}"`
  end

  link_print = proc do |source, target|
    puts({source: source.to_s, target: target.to_s})
  end

  candidates = link_candidates()
  folders = candidates.map {|tuple| tuple[1]}.map(&:dirname).uniq

  # Make sure all folders exist
  folders.each(&:mkpath)
  candidates.each(&unsplat(&link))
end

task :uninstall do
  link_candidates().each do |link|
    source, target = *link

    if target.symlink? && (source == target.readlink)
      puts "removing #{target}"
      target.unlink()
    end
    backup_file = target.dirname+("#{target.basename}.backup")
    if backup_file.exist?
      puts "restoring #{backup_file} from backup"
      backup_file.rename(target)
    end
  end
end

desc "Do everything that can be safely run after pulls"
task :default => 'install'

desc "Do everything"
task :all => 'default'
