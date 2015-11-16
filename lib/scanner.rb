
class Scanner

  def execute(file_path)
    start_time = Time.now
    write_output(scan_dictionary(load_dictionary(file_path)))
    puts ("\nElapsed seconds: #{Time.now - start_time}")
  end

  def load_dictionary(file_path)
    raise ArgumentError.new('Path to file required') if file_path.nil? || file_path.empty?
    File.readlines(file_path).each {|line| line.chomp!}
  end

  def scan_dictionary(dictionary)
    duplicate_sequences = []

    words_by_sequence = {}
    dictionary.each do |word|

      sequences_from_word(word).each do |sequence|
        if words_by_sequence.has_key?(sequence)
          duplicate_sequences << sequence
        else
          words_by_sequence[sequence] = word
        end
      end

    end
    duplicate_sequences.each { |sequence| words_by_sequence.delete(sequence)}
    words_by_sequence
  end

  def sequences_from_word(word)
    word.scan(/(?=([a-zA-Z]{4}))/).flatten
  end

  def write_output(output)
    # create/open both files
    sequence_file = File.open(sequence_file_name, 'w')
    word_file = File.open(word_file_name, 'w')

    output.each_pair do |sequence, word|
      sequence_file.puts(sequence)
      word_file.puts(word)
    end
    sequence_file.close
    word_file.close
  end

  def sequence_file_name
    data_file_name('sequence.txt')
  end

  def word_file_name
    data_file_name('word.txt')
  end

  def data_file_name(file_name)
    "data/#{file_name}"
  end

end

