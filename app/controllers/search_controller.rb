class SearchController < ApplicationController
  
  def search
    @query = params[:query]
    @query = 'http://mt7.de' if @query.blank?
    @query = Site.normalize_url(@query)
    @sites = Site.find(:all, :conditions => "url LIKE '#{@query}%'")
    @claim = Claim.new(:url => @query)
    @naming = Naming.new(:url => @query)
  end
  
end
