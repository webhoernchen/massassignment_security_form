require 'openssl'
require 'digest/sha1'

module MassassignmentSecurityForm
  class Config
    SSL_VERSION = "AES-256-CBC"
    MASSASSIGNMENT_PARAMS_NAME = "massassignment_fields"

    class << self
      attr_writer :password
      attr_accessor_with_default :remove_not_allowed_massassignment_fields, true

      def password
        @password || raise("Please define #{self.name}.password in your initializer")
      end
    end
  end
  
  class MassassignmentColumnsHash
    class << self
      def encrypt(string)
        cipher = OpenSSL::Cipher::Cipher.new(Config::SSL_VERSION)
        cipher.encrypt
        # your pass is what is used to encrypt/decrypt
        cipher.key = password_key
        cipher.iv = iv = cipher.random_iv
        encrypted = cipher.update(string)
        encrypted << cipher.final
        
        Base32.encode({:iv => Base32.encode(iv), :encrypted => Base32.encode(encrypted)}.to_json)
      end
      
      def decrypt(string)
        encoded = Base32.decode(string)
        encrypted_hash = JSON.parse(encoded).symbolize_keys

        cipher = OpenSSL::Cipher::Cipher.new(Config::SSL_VERSION)
        cipher.decrypt
        cipher.key = password_key
        cipher.iv = Base32.decode(encrypted_hash[:iv])
        output = cipher.update(Base32.decode(encrypted_hash[:encrypted]))
        output << cipher.final

        output
      end

      def parse_from(encrypted_string)
        begin
          decrypted_string = decrypt(encrypted_string)
          new.set_from_json decrypted_string
        rescue Exception => e
          warn = ["Massassignment Warning:"]
          warn << "Can not parse encryted_string '#{encrypted_string}'"
          warn << e.message
          Rails.logger.warn warn.join("\n")
          new
        end
      end

      private
      def password_key
        @password_key ||= Digest::SHA1.hexdigest(Config.password).unpack('a2'*32).map{|x| x.hex}.pack('c'*32)
      end
    end

    def set_from_json(json)
      @form_columns = JSON.parse(json)
      self
    end

    def add_column(object_name, method_name)
      form_columns_for(object_name) << method_name.to_s \
        unless form_columns_for(object_name).include?(method_name.to_s)
    end

    def to_encrypted_string
      self.class.encrypt form_columns.to_json
    end

    def form_columns
      @form_columns ||= {}
    end

    def remove_not_allowed_massassignments_from(params)
      allowed_keys = form_columns.stringify_keys.keys
      params.each do |key, value| 
        if value.is_a?(Hash) && !allowed_keys.include?(key.to_s)
          value.clear
        end
      end
      
      params.each do |massassignment_key, value| 
        if value.is_a?(Hash)
          attrs = form_columns_for(massassignment_key.to_s).collect(&:to_s)
          value.reject! do |attr, attr_value|
            attr_name = attr.to_s
            # normale Attribute
            # oder date_select attribute
            !(attrs.include?(attr_name) || attrs.include?(attr_name.gsub(/\([1-6]i\)$/, '')))
          end
        end
      end
    end

    private
    def form_columns_for(object_name)
      form_columns[object_name.to_s] ||= []
    end
  end
end
