require 'json'

def retrive_chapters(file_path)
  content = File.read(file_path)
  JSON.parse(content)
end

def reject_chapters_with_no_problems(chapters)
  chapters.reject do |chapter|
    chapter['groups'].all? { |group| group['pending'].none? }
  end
end

def get_random_group_with_problems(chapter)
  chapter['groups'].select { |g| g['pending'].any? }.sample
end

def persit_chapters(chapters, file_path)
  File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(chapters)) }
end

def delete_random_item(array)
  array.delete_at(rand(0...array.count))
end

def get_random_chapters(chapters, count)
  # chapters.shuffle[0...count]
  # Kind of random :) Let's use this approach for now.
  sort_chapters_by_solved_count(chapters)[0...count]
end

def count_solved_problems(chapter)
  chapter['groups'].sum { |g| g['solved'].count }
end

def sort_chapters_by_solved_count(chapters)
  chapters.sort do |c1, c2|
    count_solved_problems(c1) <=> count_solved_problems(c2)
  end
end

chapters_count = ARGV[0].to_i
CHAPTERS_COUNT = chapters_count.positive? ? chapters_count : 4
FILE_PATH = File.join(__dir__, 'data', 'chapters.json')

chapters = retrive_chapters(FILE_PATH)
random_chapters = get_random_chapters(reject_chapters_with_no_problems(chapters), CHAPTERS_COUNT)

random_chapters.each do |chapter|
  group = get_random_group_with_problems(chapter)
  problem = delete_random_item(group['pending'])
  group['solved'] << problem
  group['solved'].sort!

  puts "#{chapter['name']} - #{group['name']} - #{problem}"
end

persit_chapters(chapters, FILE_PATH)
