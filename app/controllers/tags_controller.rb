###
# REST controller for fetching +Tag+ records

class TagsController < ApplicationController
  before_filter :authenticate_user!

  # GET /tags
  # @return [void]
  def index
    @tags = current_user.tags

    respond_to do |format|
      format.html{ render :json => @tags }
      format.json { render :json => @tags }
    end

  end

end
