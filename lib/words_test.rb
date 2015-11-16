require_relative('scanner')

if ARGV[0].nil?
  puts('-----------------------------------------------')
  puts('Usage:')
  puts('ruby lib/words_test.rb (dictionary_file_name)')
  puts
  puts 'Example:'
  puts 'ruby lib/words_test.rb data/dictionary.txt'
  puts
  puts 'Assumptions:'
  puts '- the specified input file must reside on the local file system.'
  puts('-----------------------------------------------')
else
  Scanner.new.execute(ARGV[0])
end
