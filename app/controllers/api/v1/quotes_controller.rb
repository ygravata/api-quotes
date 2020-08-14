class Api::V1::QuotesController < Api::V1::ApplicationController
  # both open-uri and nokogiri are used to do the scraping part
  require 'open-uri'
  require 'nokogiri'
  
  # def search_tag
  #   @search_tag = SearchTag.find_by(name: params[:search_tag])
  #   if @search_tag.searched == true
  #     @quotes = set_quotes(@search_tag)
  #   elsif @search_tag.searched == false
  #     scrapping_quotes(@search_tag)
  #     @search_tag.searched = true
  #     @search_tag.save
  #     @quotes = set_quotes(@search_tag)
  #   else
  #     @new_search_tag = SearchTag.create!(name: params[:search_tag])
  #     scrapping_quotes(@new_search_tag)
  #     @quotes = Quote.where(search_tag_id: @new_search_tag.id).to_a       
  #   end
  # end

  def search
  # method to verify if the tag inserted into the endpoint was previously searched or not
    
    # if was searched before, will attend first condition and will display quotes through class method quotes_with_search_tags
    if @search_tag = SearchTag.find_by(name: params[:search_tag])
      @quotes = Quote.quotes_with_search_tags(@search_tag)
    else
    # if was not searched before, will attend second condition and will scrap quotes through class method quotes_with_search_tags
      @new_search_tag = SearchTag.create!(name: params[:search_tag])
      scrapping_quotes(@new_search_tag)
      @quotes = Quote.quotes_with_search_tags(@new_search_tag) 
    end
   end
     
  private

  def scrapping_quotes(search_tag)
    # method to scrap, through nokogiri
    url = "http://quotes.toscrape.com/tag/#{search_tag.name}"
    
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    
     html_doc.search('.quote').each do |card|
        quote_text = card.search('.text').text.strip

        author_name = card.search('.author').text.strip
        author_about = "http://quotes.toscrape.com#{card.css('a').attribute('href').value}"

        author = set_author(author_name, author_about)
        quote = set_quote(quote_text, author, search_tag) 
        
        card.search('.tag').each do |tag|
          # here the tags present in one quote, will be added in the quote object as an array. 
          quote.add_to_set(tag_list: tag.text.strip)
        end        
      end
  end
  
  def set_author(name_param, about_param)
    # method to return an author if the said author was already created, or create a new actor if not
    if Author.find_by(name: name_param)
      Author.find_by(name: name_param)
    else
      Author.create(name:name_param, author_about: about_param)
    end
  end
  
  def set_quote(quote_text_param, author_param, search_tag_param)
    # method to verify if the quote was already created (will return the existing quote) or not (will create a new quote).
    # all the quotes (new or old) will receive the search_tag of the endpoint
    # this way, we won't create quotes in duplicates, when searching each of the tags included in one specific quote
    if Quote.find_by(quote: quote_text_param)
      quote = Quote.find_by(quote: quote_text_param)
      quote.search_tags << search_tag_param
      quote
    else
      quote = Quote.create!(quote: quote_text_param, author: author_param.id, 
      author_about: author_param.author_about)
      quote.search_tags << search_tag_param
      quote
    end
  end

  # def set_quotes(search_tag_param)
  #   Quote.where(search_tag_id: search_tag_param.id).to_a 
  # end
 
end
