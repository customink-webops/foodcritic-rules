#
# CustomInk Foodcritic Rules
# Copyright 2012, CustomInk, LLC
#

rule 'CINK001', 'Missing CHANGELOG in markdown format' do
  tags %w{style changelog}
  cookbook do |path|
    filepath = File.join(path, 'CHANGELOG.md')
    unless File.exists?(filepath)
      [ file_match(filepath) ]
    end
  end
end

rule 'CINK003', 'Don\'t hardcode apache user or group' do
  tags %w{bug}
  cookbook do |path|
    recipes = Dir["#{path}/**/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)

      lines.collect.with_index do |line, index|
        if line.match('(group|owner)\s+[\\\'\"](apache|www-data|http|www)[\\\'\"]')
          {
            :filename => recipe,
            :matched => recipe,
            :line => index+1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end
