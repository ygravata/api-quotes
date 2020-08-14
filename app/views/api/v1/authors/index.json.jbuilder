json.authors @authors do |author|
    json.author author.name
    json.author_about author.author_about
    
    @quotes = Quote.where(author_id: author.id).to_a
    json.quotes @quotes do |quote|
      json.quote quote.quote
    end
end


