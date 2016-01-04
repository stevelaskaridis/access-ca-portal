module TypeHelpers

  HOSTNAME_REGEX = /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}/ix
  URL_REGEX = /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix
  PERSON_NAME_REGEX = /[A-Z][a-z]* [A-Z][a-z]*/

  def self.isPerson?(subject_dn)
    if (subject_dn.split('CN=')[1].split('/subjectAltName')[0] =~ /\A#{PERSON_NAME_REGEX}\z/) == 0
      true
    else
      false
    end
  end

  def self.isHost?(subject_dn)
    if (subject_dn.split('CN=')[1].split('/subjectAltName')[0] =~ /\A#{HOSTNAME_REGEX}\z/) == 0
      true
    else
      false
    end
  end

end