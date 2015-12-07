require 'socket'

class HostnameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless hostname_format_valid? value
      record.errors[attribute] << (options[:message] || "is not a hostname")
    else
      unless hostname_dns_valid? value
        record.errors[attribute] << ("could not be resolved")
      end
    end
  end

  def self.hostname_format_valid?(hostname)
    if (hostname =~ /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix).nil?
      false
    else
      true
    end
  end

  def self.hostname_dns_valid?(hostname)
    begin
      IPSocket.getaddress(hostname)
    rescue SocketError => e
      false
    end
  end
end