class RaController < ApplicationController

  def csr_list
  end

  def csr_pending
    @csr = CertificateRequest.where( status: 'pending')
  end

  def csr_rejected
    @csr = CertificateRequest.where( status: 'rejected')
  end

  def csr_approved
    @csr = CertificateRequest.where( status: 'approved')
  end
end
