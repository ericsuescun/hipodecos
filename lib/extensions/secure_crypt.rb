module SecureCrypt
  ENCRYPTION_KEY = ENV['PSS_ENCRYPTION_KEY']
  ALGORITHM_TYPE = 'aes-256-cbc'

  class << self
    def encrypt_value(value)
      base_cypher(:encrypt, value)
    end

    def decrypt_value(value)
      base_cypher(:decrypt, value)
    end

    def base_cypher(cipher_action, value)
      cipher = OpenSSL::Cipher.new(ALGORITHM_TYPE)
      cipher.send(cipher_action)
      cipher.pkcs5_keyivgen(ENCRYPTION_KEY)
      result = cipher.update(value)
      result << cipher.final
    end
  end
end
