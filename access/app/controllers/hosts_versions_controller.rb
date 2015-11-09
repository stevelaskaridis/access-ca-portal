class HostsVersionsController < ApplicationController
  def index
    @host = Host.find(params[:host_id])
    @host_versions = @host.versions
  end
end
