class SiteController < ApplicationController
  def index
    if current_user && TmpAdmin.is_admin?(current_user)
      @admin = true
    else
      @admin = false
    end
  end
end
