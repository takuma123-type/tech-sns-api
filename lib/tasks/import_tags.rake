require 'csv'

namespace :import do
  desc "Import tags from CSV"
  task tags: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'tags.csv')

    CSV.foreach(csv_file_path, headers: true) do |row|
      Tag.find_or_create_by(name: row['name'])
    end

    puts "Tags imported successfully!"
  end
end
