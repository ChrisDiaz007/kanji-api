namespace :export do
  desc "Export kanji data to JSON file"
  task kanji: :environment do
    require 'json'

    puts "📤 Exporting kanji data..."

    kanji_data = Kanji.all.map do |kanji|
      {
        character: kanji.character,
        meanings: kanji.meanings,
        onyomi: kanji.onyomi,
        kunyomi: kanji.kunyomi,
        name_readings: kanji.name_readings,
        notes: kanji.notes,
        heisig_en: kanji.heisig_en,
        stroke_count: kanji.stroke_count,
        grade: kanji.grade,
        jlpt_level: kanji.jlpt_level,
        freq_mainichi_shinbun: kanji.freq_mainichi_shinbun,
        unicode: kanji.unicode,
        created_at: kanji.created_at,
        updated_at: kanji.updated_at
      }
    end

    File.write('db/kanji_data.json', JSON.pretty_generate(kanji_data))
    puts "✅ Exported #{kanji_data.size} kanji to db/kanji_data.json"
  end
end
