json.quotes @quotes do |quote|
    json.quote quote.quote
    json.author quote.author.name  
    json.author_about quote.author_about
    json.tags quote.tag_list do |tag|
      json.tag tag
    end
end