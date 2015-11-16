## Synopsis

Given a dictionary, words_test generates two output files, 'sequences' and 'words'. 'sequences' contains every sequence of four letters (A-z) that appears in exactly one word of the dictionary, one sequence per line. 'words' contains the corresponding words that contain the sequences, in the same order, one per line.

## Code Example

## Motivation

## Installation
Setup the environment:  
- the code was tested using Ruby version 2.2.3p173
- there are no other runtime dependencies
- download the project and extract it into a working directory
- change the current directory to the working directory


Usage:  
ruby lib/words_test.rb (dictionary_file_name)

Example:  
ruby lib/words_test.rb data/dictionary.txt

Assumptions:
- execute from words_test directory
- the specified input file must reside on the local file system

## API Reference

## Tests

If SimpleCov is not installed, run bundle install:  
bundle install  

From the words_test directory, execute rspec using the bundle version if necessary:  
rspec  
OR  
bundle exec rspec

## Contributors


## License

None

