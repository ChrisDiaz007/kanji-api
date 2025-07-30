namespace :import do
  desc "Import kanji data from JSON file"
  task kanji_from_json: :environment do
    require 'json'

    json_file = 'db/kanji_data.json'

    unless File.exist?(json_file)
      puts "❌ File #{json_file} not found. Run 'rails export:kanji' first."
      exit 1
    end

    puts "📥 Importing kanji data from #{json_file}..."

    kanji_data = JSON.parse(File.read(json_file))

    kanji_data.each_with_index do |data, index|
      print "⛏️  [#{index + 1}/#{kanji_data.size}] #{data['character']} ... "

      Kanji.create_with(
        meanings: data['meanings'],
        onyomi: data['onyomi'],
        kunyomi: data['kunyomi'],
        name_readings: data['name_readings'],
        notes: data['notes'],
        heisig_en: data['heisig_en'],
        stroke_count: data['stroke_count'],
        grade: data['grade'],
        jlpt_level: data['jlpt_level'],
        freq_mainichi_shinbun: data['freq_mainichi_shinbun'],
        unicode: data['unicode'],
        created_at: data['created_at'],
        updated_at: data['updated_at']
      ).find_or_create_by!(character: data['character'])

      puts "✅"
    end

    puts "🎉 Done! #{kanji_data.size} kanji imported from JSON."
  end
end
