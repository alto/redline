class SearchController < ApplicationController
  
  def search
    @query = params[:query]
    @query = 'http://mt7.de' if @query.blank?
    @sites = Site.find(:all, :conditions => "url LIKE '#{params[:query]}%'")
  end
  
end
