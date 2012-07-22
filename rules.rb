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

rule 'CINK002', 'Prefer single-quoted strings' do
  tags %w{style strings}
  cookbook do |path|
    recipes = Dir["#{path}/**/*.rb"]
    recipes.collect do |recipe|
      lines = File.read(recipe).split("\n")

      lines.collect.with_index do |line, index|
        # Don't flag if there is a #{} or ' in the line
        if line.match('"(.*)"') && !line.match('\'(.*)"(.*)"(.*)\'') && !line.match('"(.*)(#{.+}|\'|\\\a|\\\b|\\\r|\\\n|\\\s|\\\t)(.*)"')
          {
            :filename => recipe,
            :matched => recipe,
            :line => index + 1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end
