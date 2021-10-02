class EncryptedField
  def load(value)
    return if value.blank? || String(value).include?('error')

    Marshal.load(SecureCrypt.decrypt_value(Base64.strict_decode64(value)))
  end

  def dump(value)
    return if value.blank? || String(value).include?('error')

    Base64.strict_encode64(SecureCrypt.encrypt_value(Marshal.dump(value)))
  end
end
