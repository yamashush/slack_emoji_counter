require 'json'

DIR = './slack_export_data'

counter_hash = Hash.new

# only channel sub-directories yyyy-mm-dd.json file
Dir.glob("#{DIR}/*/*.json") do |file|

  # only messages include reaction
  reactions = JSON.load(File.open(file)).select { |msg| msg['reactions'] }
    .map { |msg| msg['reactions'] }.flatten

  reactions.each do |reaction|
    if counter_hash.has_key?(reaction['name'])
      counter_hash[reaction['name']] += reaction['count']
    else
      counter_hash[reaction['name']] = reaction['count']
    end
  end

end

counter_hash
  .sort_by { |key, value| value }
  .reverse
  .each { |key, value| puts "#{key} #{value}" }
