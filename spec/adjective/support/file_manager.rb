require 'fileutils'

module FileManager
  def config_file
    "#{Rails.root}/config/initializers/adjective.rb"
  end

  def self.truncate_files(directory_path)
    if Dir.exist?(directory_path)
      Dir.foreach(directory_path) do |file|
        next if file == '.' || file == '..' || File.directory?(File.join(directory_path, file))
        File.delete(File.join(directory_path, file))
      end
    else
      puts "Directory does not exist: #{directory_path}"
    end
  end
end


# Iterate through files in the directory and delete them
