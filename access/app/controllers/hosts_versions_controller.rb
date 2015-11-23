class HostsVersionsController < ApplicationController
  before_filter :authorize!
  def index
    @host = Host.find(params[:host_id])
    @host_versions = @host.versions
  end

  private
    def authorize!
      redirect_to hosts_url, alert: "#{I18n.t 'controllers.authorization.not_authorized'}" unless TmpAdmin.is_admin?(current_user)
    end
end
