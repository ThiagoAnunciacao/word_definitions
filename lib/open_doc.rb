require 'sequel'
require 'yomu'
require 'pry'
require 'parallel'
require 'rest-client'

# links usados
# http://wordnetweb.princeton.edu/perl/webwn?s=afterwards&sub=Search+WordNet&o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&h=0
# https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=pt-BR&dt=t&q=worms
# https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&search=elf-friends&namespace=0&limit=10&suggest=true
# http://www.dictionary.com/browse/the?s=t

db = Sequel.mysql2(host: 'localhost', user: 'root', password: '', database: 'utilidades')

word_definitions = db[:word_definitions]

# File.open('dict/verbs.forms', 'rb').each_with_index do |row, index|
#   next if index < 1

#   line = row.gsub('  ', ' ').split(' ')

#   word_definitions.insert({type: 'verbo', word: line[1].downcase.strip, definition: 'Base Form', original_word: line[1].strip})
#   word_definitions.insert({type: 'verbo', word: line[2].downcase.strip, definition: 'Past Form', original_word: line[2].strip})
#   word_definitions.insert({type: 'verbo', word: line[3].downcase.strip, definition: 'Participle Form', original_word: line[3].strip})
#   word_definitions.insert({type: 'verbo', word: line[4].downcase.strip, definition: 's / es/ ies', original_word: line[4].strip})
#   word_definitions.insert({type: 'verbo', word: line[5].downcase.strip, definition: '‘ing’ form', original_word: line[5].strip})
# end

type = 'adjetivo'
File.open('dict/data.adj', 'rb').each_with_index do |row, index|
  next if index < 29

  line_splited = row.split('|')
  word = line_splited[0].split(' ')[4]
  definition = line_splited[1]
  synonymous = line_splited[0].split(' ')

  word = word.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")

  synonymou = synonymous[6] =~ /[0-9]/ ? nil : synonymous[6].downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
  word_definitions.insert({type: type, word: word, synonymous: synonymou, definition: definition})

  if synonymous.size > 0
    synonymous.each do |synonymou|
      if synonymou =~ /[0-9]/
        synonymou = nil
      else
        if synonymou.size > 2
          synonymou = synonymou.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
        else
          synonymou = nil
        end
      end

      next if synonymou == nil

      next if word == synonymou

      dataset = db["SELECT `word` FROM `word_definitions` WHERE `type` = \"#{type}\" AND `word` = \"#{word}\" AND `synonymous` = \"#{synonymou}\""]

      if dataset.count == 0
        word_definitions.insert({type: type, word: synonymou, synonymous: word, definition: definition})
      end
    end
  end
end

type = 'adverbio'
File.open('dict/data.adv', 'rb').each_with_index do |row, index|
  next if index < 29

  line_splited = row.split('|')
  word = line_splited[0].split(' ')[4]
  definition = line_splited[1].gsub('"', "\"")
  synonymous = line_splited[0].split(' ')

  word = word.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")

  synonymou = synonymous[6] =~ /[0-9]/ ? nil : synonymous[6].downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
  word_definitions.insert({type: type, word: word, synonymous: synonymou, definition: definition})

  if synonymous.size > 0
    synonymous.each do |synonymou|
      if synonymou =~ /[0-9]/
        synonymou = nil
      else
        if synonymou.size > 2
          synonymou = synonymou.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
        else
          synonymou = nil
        end
      end

      next if synonymou == nil

      next if word == synonymou

      dataset = db["SELECT `word` FROM `word_definitions` WHERE `type` = \"#{type}\" AND `word` = \"#{word}\" AND `synonymous` = \"#{synonymou}\""]

      if dataset.count == 0
        word_definitions.insert({type: type, word: synonymou, synonymous: word, definition: definition})
      end
    end
  end
end

type = 'substantivo'
File.open('dict/data.noun', 'rb').each_with_index do |row, index|
  next if index < 29

  line_splited = row.split('|')
  word = line_splited[0].split(' ')[4]
  definition = line_splited[1].gsub('"', "\"")
  synonymous = line_splited[0].split(' ')

  word = word.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")

  synonymou = synonymous[6] =~ /[0-9]/ ? nil : synonymous[6].downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
  word_definitions.insert({type: type, word: word, synonymous: synonymou, definition: definition})

  if synonymous.size > 0
    synonymous.each do |synonymou|
      if synonymou =~ /[0-9]/
        synonymou = nil
      else
        if synonymou.size > 2
          synonymou = synonymou.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
        else
          synonymou = nil
        end
      end

      next if synonymou == nil

      next if word == synonymou

      dataset = db["SELECT `word` FROM `word_definitions` WHERE `type` = \"#{type}\" AND `word` = \"#{word}\" AND `synonymous` = \"#{synonymou}\""]

      if dataset.count == 0
        word_definitions.insert({type: type, word: synonymou, synonymous: word, definition: definition})
      end
    end
  end
end

type = 'verbo'
File.open('dict/data.verb', 'rb').each_with_index do |row, index|
  next if index < 29

  line_splited = row.split('|')
  word = line_splited[0].split(' ')[4]
  definition = line_splited[1].gsub('"', "\"")
  synonymous = line_splited[0].split(' ')

  word = word.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")

  synonymou = synonymous[6] =~ /[0-9]/ ? nil : synonymous[6].downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
  word_definitions.insert({type: type, word: word, synonymous: synonymou, definition: definition})

  if synonymous.size > 0
    synonymous.each do |synonymou|
      if synonymou =~ /[0-9]/
        synonymou = nil
      else
        if synonymou.size > 2
          synonymou = synonymou.downcase.strip.gsub("(p)", "").gsub("(a)", "").gsub("_", " ")
        else
          synonymou = nil
        end
      end

      next if synonymou == nil

      next if word == synonymou

      dataset = db["SELECT `word` FROM `word_definitions` WHERE `type` = \"#{type}\" AND `word` = \"#{synonymou}\" AND `synonymous` = \"#{word}\""]

      if dataset.count == 0
        word_definitions.insert({type: type, word: synonymou, synonymous: word, definition: definition})
      end
    end
  end
end

# file = 'Dicionário_Inglês-Português.doc'

# yomu = Yomu.new file
# yomu.mimetype.content_type #=> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"

# binding.pry

# yomu.mimetype.extensions #=> ['docx']

# texto = yomu.text

# start = texto.index("germain.garand@freebel.net\n\n") + "germain.garand@freebel.net\n\n".size

# array_words = texto[start..-1].split("\n\n")

# array_words.map{ |x| array_words.delete(x) if x.size == 1 }

# dicionario_ingles_portugues = db[:dicionario_ingles_portugues]

# array_words.map{ |x| x.split('– ') }.each do |words|
#   atributos = {
#     word: words[0],
#     word_translated: words[1]
#   }

#   dicionario_ingles_portugues.insert(atributos)
# end

# query = "SELECT `t1`.`word` FROM `book_words` AS `t1` LEFT JOIN `dicionario_ingles_portugues` AS `t2` ON `t2`.`word` = `t1`.`word`
#          WHERE `page` BETWEEN 10 AND 30 AND `t2`.`word` IS NULL GROUP BY `t1`.`word` ORDER BY `t1`.`word`"

# dicionario = db[:dicionario_ingles_portugues]

# rows = db[query]

# Parallel.each(rows.map{|x| x[:word] }, in_threads: 5) do |row|
#   word = row.gsub("’", "'").gsub("-", " ")

#   url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=pt&dt=t&q=#{word}"

#   begin
#     result = RestClient.get(url)
#   rescue Exception => e
#     binding.pry
#   end

#   word_translated = /[[:alpha:][ ]]+/.match(result.body.split(',').first)[0]

#   atributos = {
#     word: word,
#     word_translated: word_translated
#   }

#   dicionario.insert(atributos)
# end

# word = 'although'
# new_url = "https://translate.googleapis.com/translate_a/single?client=p&sl=en&tl=pt-BR&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&q=clock"

# binding.pry

# result = RestClient.get(url)
# # Rack::Utils.parse_nested_query(response.gsub(/,+/, ",").gsub(/\[,/, "[").gsub("\"", ""))







# roman_numbers = ['II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII',
#                  'XIX', 'XX', 'XXI', 'XXII', 'XXIII', 'XXIV', 'XXV', 'XXVI', 'XXVII', 'XXVIII', 'XXIX', 'XXX', 'XXXI', 'XXXII',
#                  'XXXIII', 'XXXIV', 'XXXV', 'XXXVI', 'XXXVII', 'XXXVIII', 'XXXIX', 'XL', 'XLI', 'XLII', 'XLIII', 'XLIV', 'XLV',
#                  'XLVI', 'XLVII', 'XLVIII', 'XLIX', 'L', 'LI', 'LII', 'LIII', 'LIV', 'LV', 'LVI', 'LVII', 'LVIII', 'LIX', 'LX',
#                  'LXI', 'LXII', 'LXIII', 'LXIV', 'LXV', 'LXVI', 'LXVII', 'LXVIII', 'LXIX', 'LXX', 'LXXI', 'LXXII', 'LXXIII',
#                  'LXXIV', 'LXXV', 'LXXVI', 'LXXVII', 'LXXVIII', 'LXXIX', 'LXXX', 'LXXXI', 'LXXXII', 'LXXXIII', 'LXXXIV', 'LXXXV',
#                  'LXXXVI', 'LXXXVII', 'LXXXVIII', 'LXXXIX', 'XC', 'XCI', 'XCII', 'XCIII', 'XCIV', 'XCV', 'XCVI', 'XCVII', 'XCVIII', 'XCIX', 'C']

# regex_ful_names = Regexp.new("[A-Z]([a-z]+|\.)(?:\s+[A-Z]([a-z]+|\.))*(?:\s+[a-z][a-z\-]+){0,2}\s+[A-Z]([a-z]+|\.)")

# book_words = db[:book_words]

# pdf_file = 'The-Hobbit-pdf.pdf'

# book = 'The Hobbit'

# require 'pdf-reader'

# reader = PDF::Reader.new(pdf_file)

# start_page = 10

# reader.pages.each do |page|
#   next if page.number.to_i < start_page

#   # puts page.fonts
#   # puts page.text
#   # puts page.raw_content

#   paragraph_number = 0
#   page.text.gsub("\n\n\n\n\n\n\n\n\n\n", " ").gsub("\n\n   ", "\n   ").split("\n   ").each do |paragraph|
#     page_number = (page.number - 7)
#     paragraph_number += 1
#     line_number = 0
#     paragraph.gsub("\n\n", "\n").gsub("-\n", "-").split("\n").each do |line|
#       line_number += 1
#       next if line == '' || line == nil || line == ' '

#       texto = line.gsub("   ", "").gsub(/[!†@*%&‘\"“”,.:?!();`0-9"]/, '')

#       names = texto.to_enum(:scan, regex_ful_names).map { Regexp.last_match }

#       names.each do |name|
#         name = name[0].strip
#         next if name =~ /^[A-Z -]+(?:)?$/
#         db.run("insert ignore into names values (NULL, \"#{book}\", \"#{name}\", #{line_number}, #{paragraph_number}, #{page_number})")
#       end

#       words = texto.split(' ').map{ |x| x.split('—') }.flatten

#       Parallel.each(words, in_threads: 5) do |word|
#         original_word = word.chomp("’").strip
#         original_word.slice!('a-')

#         if original_word =~ /^[A-Z]/
#           original_word_downcase = original_word.downcase

#           dataset = db["SELECT `word` FROM `book_words` WHERE `book` = \"#{book}\" AND `original_word` LIKE BINARY \"#{original_word_downcase}\""]

#           if dataset.count > 0
#             word = original_word_downcase.chomp("-")
#             db.run("UPDATE `book_words` SET `word` = '#{word}' WHERE `book` = \"#{book}\" AND `original_word` = \"#{original_word_downcase}\"")
#           else
#             word = original_word.chomp("-")
#           end
#         else
#           word = original_word.downcase.chomp("-")
#         end

#         next if word == '' || word == nil || word == ' ' || word == '----'

#         next if word.size == 1 && (word != 'a' && word != 'i' && word != 'o')

#         next if roman_numbers.include?(original_word)

#         db.run("insert ignore into `book_words` values (NULL, \"#{book}\", \"#{word}\", #{page_number},  \"#{original_word}\",
#                 \"#{line.strip}\", #{line_number}, \"#{paragraph.strip}\", #{paragraph_number})")
#       end
#     end
#   end
# end
