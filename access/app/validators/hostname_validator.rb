require 'socket'
require 'helpers/type_helpers'

class HostnameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless HostnameValidator.hostname_format_valid? value
      record.errors[attribute] << (options[:message] || "is not a hostname")
    else
      unless HostnameValidator.hostname_dns_valid? value
        record.errors[attribute] << ("could not be resolved")
      end
    end
  end

  def self.hostname_format_valid?(hostname)
    if (hostname =~ /\A#{TypeHelpers::HOSTNAME_REGEX}\z/ix).nil?
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