conn ||= ActiveRecord::Base.connection

    Wordnik.configure do |config|
      config.api_key = 'f8b8b90590adef0ee030d03d12e018fbe3f72944e9e73a70c'               # required
      # config.username = 'thiago.anunciacao'                    # optional, but needed for user-related functions
      # config.password = 'cl0wnt0wn'               # optional, but needed for user-related functions
      # config.response_format = 'json'             # defaults to json, but xml is also supported
      # config.logger = Logger.new('/dev/null')     # defaults to Rails.logger or Logger.new(STDOUT). Set to Logger.new('/dev/null') to disable logging.
    end

    @book_words = Words.joins('LEFT JOIN `definitions` on `definitions`.`word_id` = `words`.`id`
                               LEFT JOIN `definitions_wordnik` on `definitions_wordnik`.`word_id` = `words`.`id`')
                           .select('`words`.`id`, `words`.`word` AS `word`')
                           .group('`words`.`id`')
                           .where('`definitions`.`id` IS NULL')
                           .where('`definitions_wordnik`.`id` IS NULL')
                           .order('`words`.`word`')

    @book_words.each do |word|
      word_id = word.id
      word = word.word

      begin
        word_definitions = Wordnik.word.get_definitions(word, use_canonical: true)

        values = ''
        word_definitions.each do |wd|
          source_dictionary = wd['sourceDictionary']
          attribution_text = wd['attributionText']
          sequence = wd['sequence'].to_i
          part_of_speech = wd['partOfSpeech']
          text_definition = wd['text']
          attribution_url = wd['attributionUrl']
          values << "(#{word_id}, #{conn.quote(word)}, #{sequence}, #{conn.quote(source_dictionary)}, #{conn.quote(attribution_text)}, #{conn.quote(part_of_speech)}, #{conn.quote(text_definition)}, #{conn.quote(attribution_url)}, true),"
        end

        if values.present?
          conn.execute("INSERT IGNORE INTO `definitions_wordnik` (`word_id`, `word`, `sequence`, `source_dictionary`, `attribution_text`, `part_of_speech`, `text_definition`, `attribution_url`, `use_canonical`)
                        VALUES #{values.chomp(',')} ON DUPLICATE KEY UPDATE `word_id` = `word_id`;")
        end
      rescue Exception => e
        byebug
      end
    end

    abort

    @book_words.each do |word|
    # ['boatmen'].each do |word|
      # word_id = 574
      word_id = word.id
      word = word.word

      next if word =~ /^[A-Z]/

      begin
        page = Nokogiri::HTML(open("http://www.dictionary.com/browse/#{word}"))
      rescue
        next
      end

      pages = page.css('.source-box').first.css('.def-pbk') rescue next

      pages.each do |row|
        begin
          word_type = row.children.children.css('.dbox-pg').first.children.text.strip.downcase
        rescue
          types = ['noun', 'article', 'pronoun', 'verb', 'auxiliary verb', 'adverb', 'adjective', 'conjunction', 'preposition', 'interjection', 'contraction']

          word_type = row.children.children[0].text.strip rescue page.css('.dbox-pg').first.text.strip.downcase

          if word_type.blank?
            word_type = page.css('.dbox-pg').first.text.strip.downcase rescue next
          end

          unless types.include?(word_type)
            p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            p "Word Type: #{word_type}"
            p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            next
          end
        end

        rows = row.children.css('.def-set')

        case word_type
        when 'noun'
        when 'article'
        when 'pronoun'
        when 'verb', 'auxiliary verb'
          word_type = 'verb'
        when 'adverb'
        when 'adjective'
        when 'conjunction'
        when 'preposition'
        when 'interjection'
        when 'contraction'
        else
          if word_type.index('noun')
            word_type = 'noun'
          elsif word_type.index('pronoun')
            word_type = 'pronoun'
          elsif word_type.index('verb')
            word_type = 'verb'
          elsif word_type.index('adverb')
            word_type = 'adverb'
          elsif word_type.index('adjective')
            word_type = 'adjective'
          elsif word_type.index('conjunction')
            word_type = 'conjunction'
          elsif word_type.index('preposition')
            word_type = 'preposition'
          elsif word_type.index('interjection')
            word_type = 'interjection'
          elsif word_type.index('article')
            word_type = 'article'
          else
            if word_type.blank? || word_type == 'idioms'
              next
            else
              # conn.execute("DELETE FROM `definitions` WHERE `word_id` = #{word_id}")

              p '###############################'
              p '###############################'
              p word
              p word_type
              p '###############################'
              p '###############################'
              # byebug
              next
            end
          end
        end

        # word_type_description = row.children.children.css('.dbox-pg').children[0].text.strip rescue word_type
        word_type_description = row.children.children.map {|x| x.attr('class').index('bold') ? "<b>#{x.text}</b>" : x.text.last == ' ' ? x.text : "#{x.text}, " if x.attr('class') && x.attr('class').index('dbox') }.join.chomp(', ') rescue word_type

        word_type_description = word_type if word_type_description.blank?

        if word_type_description.blank?
          byebug
        end

        # p "|||||||||||||||||||||||||||||||||||||||||||||||||||"
        # p "Word Type: #{word_type}"
        # p "Word Type Desc: #{word_type_description}"

        values = ''

        rows.each do |line|
          begin
            position = line.css('.def-number').text.strip.gsub(/[\W]/, '').to_i
            content = line.css('.def-content').children.text.strip
            example = line.css('.def-content .dbox-example').text

            content = content.gsub(example, '').strip

            values << "(#{word_id}, #{position}, #{conn.quote(content)}, #{conn.quote(word_type)}, #{conn.quote(word_type_description)}, #{conn.quote(example)}),"
          rescue Exception => e
            byebug
          end
        end

        if values.present?
          # conn.execute("DELETE FROM `definitions` WHERE `word_id` = #{word_id}")
          conn.execute("INSERT IGNORE INTO `definitions` (`word_id`, `position`, `definition`, `word_type`, `word_type_description`, `example`)
                        VALUES #{values.chomp(',')} ON DUPLICATE KEY UPDATE `word_id` = `word_id`;")
        end
      end
    end
