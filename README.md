## Synopsis

Given a dictionary, words_test generates two output files, 'sequences' and 'words'. 'sequences' contains every sequence of four letters (A-z) that appears in exactly one word of the dictionary, one sequence per line. 'words' contains the corresponding words that contain the sequences, in the same order, one per line.

## Code Example

## Motivation

## Installation
Ruby version 2.2.3p173 (no other runtime dependencies)
Download the lib and data folders to a words_test directory


Usage:
ruby lib/words_test.rb (dictionary_file_name)


Example:
ruby lib/words_test.rb data/dictionary.txt

Assumptions:
- execute from words_test directory
- the specified input file must reside on the local file system


## API Reference


## Tests

From the words_test directory, execute rspec:

rspec


To generate coverage while running tests:

bundle install

bundle exec rspec


## Contributors


## License

None

