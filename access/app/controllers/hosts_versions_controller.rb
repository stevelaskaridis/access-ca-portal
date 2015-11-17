class HostsVersionsController < ApplicationController
  before_filter :authorize!
  def index
    @host = Host.find(params[:host_id])
    @host_versions = @host.versions
  end

  private
    def authorize!
      redirect_to hosts_url, alert: "Not authorized!" unless TmpAdmin.is_admin?(current_user)
    end
end
