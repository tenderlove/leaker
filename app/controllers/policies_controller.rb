class PoliciesController < ApplicationController
  
  def view
    respond_to do |format|
      format.xml  { head :ok }
    end
  end
  
end