class CaController < ApplicationController
  def list_approved
    @approved_csrs = CertificateRequest.where(status: 'approved')
  end

  def upload_csrs

  end
end
