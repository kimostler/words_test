require 'spec_helper'
require_relative '../lib/scanner.rb'

describe Scanner do

  let(:dictionary) { %w[8th a Ababa aback abacus abbas back cabbage sabbath sabbatical ]  }

  let(:scan_results) {{'Abab' => 'Ababa',
                       'baba' => 'Ababa',
                       'bacu' => 'abacus',
                       'acus' => 'abacus',
                       'bbas' => 'abbas',
                       'cabb' => 'cabbage',
                       'bbag' => 'cabbage',
                       'bage' => 'cabbage',
                       'bath' => 'sabbath',
                       'bati' => 'sabbatical',
                       'atic' => 'sabbatical',
                       'tica' => 'sabbatical',
                       'ical' => 'sabbatical'} }

  describe 'load dictionary' do
    context 'when passed an existing file path' do

      it 'loads from dictionary file' do
        dictionary = subject.load_dictionary(subject.data_file_name('dictionary.txt'))
        expect(dictionary).to be
        expect(dictionary).to be_a(Array)
        expect(dictionary.first.chars.last).to_not be($/)
      end

      it 'loads an empty file' do
        dictionary = subject.load_dictionary('spec/test_data/empty.txt')
        expect(dictionary).to be
        expect(dictionary).to be_a(Array)
        expect(dictionary.size).to be(0)
      end
    end

    context 'when passed an invalid file path' do
      it 'raises error when file not found' do
        file_name = '/folder/bogus_file'
        expect{subject.load_dictionary(file_name)}.to raise_error(Errno::ENOENT, Regexp.new(file_name))
      end

      it 'raises error when nil parameter' do
        expect{subject.load_dictionary(nil)}.to raise_error(ArgumentError, /Path to file required/)
      end

      it 'raises error when empty parameter' do
        expect{subject.load_dictionary('')}.to raise_error(ArgumentError, /Path to file required/)
      end
    end
  end

  describe 'sequences_from_word' do
    context 'given words with 4 or more letters' do
      it 'finds sequences' do
        expected_sequences([ {word: 'arrows', sequences: %w[arro rrow rows]},
                             {word: 'Carrots', sequences: %w[Carr arro rrot rots]},
                             {word: 'give', sequences: %w[give]}
                           ])
      end
    end

    context 'given words with less than 4 letters' do
      it 'does not find sequences' do
        expected_sequences([{word: '', sequences: []},
                            {word: 'm', sequences: []},
                            {word: 'me', sequences: []},
                            {word: 'me3', sequences: []}
                           ])

      end
    end

    context 'given words with invalid characters' do
      it 'finds some sequences' do
        expected_sequences([ {word: 'arr1ows', sequences: []},
                             {word: 'Carr.ots', sequences: %w[Carr]},
                             {word: '_word_', sequences: %w[word]},
                             {word: 'wor d wit hsp c e s', sequences: %w[]}
                           ])

      end
    end
  end

  def expected_sequences(test_data)
    test_data.each do |data|
      sequences = subject.sequences_from_word(data[:word])
      expect(sequences).to be_a(Array)
      expect(sequences).to eql(data[:sequences])
    end
  end

  # describe 'sequence_once_in_dictionary' do
  # end

  describe 'scan_dictionary' do
    context 'given a dictionary' do
      it 'returns sequences mapped to words' do
        expect(subject.scan_dictionary(dictionary)).to eql(scan_results)
      end
    end

    context 'given empty dictionary' do
      it 'returns empty array' do
        expect(subject.scan_dictionary([])).to eql({})
      end
    end

  end

  describe 'write_output' do
    context 'given non-empty output' do
      it 'writes two non-empty files' do
        subject.write_output(scan_results)

        # two files should exist and have the correct contents
        check_file(subject.sequence_file_name, scan_results.keys)
        check_file(subject.word_file_name, scan_results.values)
      end
    end

    context 'given empty output' do
      it 'writes two empty files' do
        subject.write_output({})

        # two empty files should have been written
        check_file(subject.sequence_file_name, [])
        check_file(subject.word_file_name, [])
      end
    end
  end

  def check_file(name, expected_contents)
    expect(File.exist?(name)).to be(true)
    contents = File.readlines(name).each {|line| line.chomp!}
    expect(contents).to eql(expected_contents)
  end

  describe 'execute' do
    context 'given path to dictionary' do
      it 'writes two files with the same number of lines' do

        File.delete(subject.sequence_file_name) if File.exist?(subject.sequence_file_name)
        File.delete(subject.word_file_name) if File.exist?(subject.word_file_name)

        dictionary_file_name = 'data/dictionary.txt'
        subject.execute(dictionary_file_name)

        # two files should exist and have the correct contents
        expect(File.exist?(subject.sequence_file_name)).to be(true)
        expect(File.exist?(subject.word_file_name)).to be(true)

        full_dictionary = read_file(dictionary_file_name)
        sequences = read_file(subject.sequence_file_name)
        words = read_file(subject.word_file_name)

        # sequences and words should have same number of entries
        expect(sequences.size).to eq(words.size)

        # sequences should be smaller than the dictionary
        expect(sequences.size).to_not eq(full_dictionary.size)

        # sequences should not contain duplicates.  uniq! should not remove any entries
        expect(sequences.uniq!).to_not be

      end
    end

  end

  def read_file(name)
    File.readlines(name).each {|line| line.chomp!}
  end
end
