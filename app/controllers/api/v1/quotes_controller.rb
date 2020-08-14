class Api::V1::QuotesController < Api::V1::BaseController
  require 'open-uri'
  require 'nokogiri'
  
  acts_as_token_authentication_handler_for User
  

  def search
    
    if @tag = Tag.find_by(name: params[:search_tag]).true?
      @quotes = Quote.where(search_tag: @search_tag.id)
      
    else
      @new_search_tag = SearchTag.create!(search_tag: params[:search_tag])
      scrapping_quotes(@new_search_tag)
      @quotes = Quote.where(search_tag: @new_search_tag.id)     
    end
    
    authorize @quotes

   end
  
   
   private
 
   def scrapping_quotes(tag)
     url = "http://quotes.toscrape.com/tag/#{tag.search_tag}"
     
     html_file = open(url).read
     html_doc = Nokogiri::HTML(html_file)
     
     html_doc.search('.text').each do |element|
         quote = Quote.create!(quote: element.text.strip, search_tag_id: tag.id ) 
       # puts element.attribute('href').value
     end
   end

  def render_error
    render json: { errors: @quote.errors.full_messages },
      status: :unprocessable_entity
  end  
  
end


  #  def scrapping_quotes(tag)
  #    url = "http://quotes.toscrape.com/tag/#{tag.search_tag}"
     
  #    html_file = open(url).read
  #    html_doc = Nokogiri::HTML(html_file)
     
  #    html_doc.search('.quote').each do |card|
  #       quote = card.search('.text').text.strip
  #       author = card.search('.author').text.strip
  #       author_about = "http://quotes.toscrape.com/#{card.css('a').attribute('href').value}"
  #        quote = Quote.create!(quote: quote, search_tag_id: tag.id, author: author, author_about: author_about ) 
  #      # puts element.attribute('href').value
  #       card.search('.tag').each do |tag|
          
  #    end
  #  end

  #   if @search_tag = SearchTag.find_by(search_tag: 'inspirational')
  #     @quotes = Quote.where(search_tag: @search_tag.id)
      
  #   else
  #     @new_search_tag = SearchTag.create!(search_tag: 'inspirational')
  #     scrapping_quotes(@new_search_tag)
  #     @quotes = Quote.where(search_tag: @new_search_tag.id)     
  #   end   