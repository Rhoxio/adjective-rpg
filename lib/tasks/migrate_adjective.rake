namespace :adjective do
  namespace :db do 
    desc 'generate all migrations from adjective'
    task :generate_all_tables do 
      template_migration_content = File.read('lib/templates/all_tables.rb')
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')

      migration_name = "create_all_adjective_tables"
      new_migration_file_name = "#{timestamp}_#{migration_name}.rb"
      new_migration_path = File.join('db', 'migrate', new_migration_file_name)

      File.open(new_migration_path, 'w') do |file|
        file.write(template_migration_content)
      end

      puts "Created Adjective Migration at: #{new_migration_path}"
    end
  end
end