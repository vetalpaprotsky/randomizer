require 'json'

def retrive_sets(file_path)
  content = File.read(file_path)
  JSON.parse(content)
end

def reject_sets_with_no_elements(sets)
  sets.reject { |set| set['pending'].none? }
end

def persit_sets(sets, file_path)
  File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(sets)) }
end

def delete_random_item(array)
  array.delete_at(rand(0...array.count))
end

def get_random_items(array, count)
  array.shuffle[0...count]
end

SETS_COUNT = 3
FILE_PATH = File.join(__dir__, 'data', 'sets.json')

sets = retrive_sets(FILE_PATH)
random_sets = get_random_items(reject_sets_with_no_elements(sets), SETS_COUNT)

random_sets.each do |set|
  element = delete_random_item(set['pending'])
  set['used'] << element
  set['used'].sort!

  puts "#{set['name']} - #{element}"
end

persit_sets(sets, FILE_PATH)
