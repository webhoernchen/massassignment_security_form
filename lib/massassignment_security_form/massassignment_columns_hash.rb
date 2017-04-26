require 'openssl'
require 'digest/sha1'
require 'base32'

module MassassignmentSecurityForm
  class Config
    SSL_VERSION = "AES-256-CBC"
    MASSASSIGNMENT_PARAMS_NAME = "massassignment_fields"

    class << self
      attr_writer :password, :remove_not_allowed_massassignment_fields

      def password
        @password || raise("Please define #{self.name}.password in your initializer")
      end

      def remove_not_allowed_massassignment_fields
        if @remove_not_allowed_massassignment_fields.nil?
          @remove_not_allowed_massassignment_fields = true
        else
          @remove_not_allowed_massassignment_fields
        end
      end
    end
  end
  
  class MassassignmentColumnsHash
    class << self
      def encrypt(string)
        cipher = OpenSSL::Cipher.new(Config::SSL_VERSION)
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

        cipher = OpenSSL::Cipher.new(Config::SSL_VERSION)
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

      def params_klasses
        @params_klasses ||= [Hash, params_klass].uniq
      end

      def params_klass
        @params_klass ||= if defined? ActionController::Parameters
          ActionController::Parameters
        else
          Hash
        end
      end

      private
      def password_key
        @password_key ||= Digest::SHA1.hexdigest(Config.password).unpack('a2'*32).map{|x| x.hex}.pack('c'*32)
      end
    end

    delegate :params_klasses, :to => :class

    def set_from_json(json)
      @form_columns = JSON.parse(json)
      self
    end

    def add_column(object_name, method_name)
      form_columns_for(object_name) << method_name.to_s \
        unless form_columns_for(object_name).include?(method_name.to_s)
    end

    def add_nested_column(object_name, nested, many_reflection, method_name)
      columns = form_columns_for(object_name)
      nested_columns = columns.detect do |item|
        item.is_a?(Hash) && item.keys.collect(&:to_sym).include?(nested.to_sym)
      end

      unless nested_columns
        nested_columns ||= {nested => {:columns => [], :many_reflection => many_reflection}}
        columns << nested_columns
      end

      nested_columns = nested_columns[nested][:columns]
      
      nested_columns << method_name.to_s \
        unless nested_columns.include?(method_name.to_s)
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
        if params_klasses.any? {|k| value.is_a? k } && !allowed_keys.include?(key.to_s)
          params[key] = {}
        end
      end
      
      remove_not_allowed_massassignments_recursiv_from params
    end
    
    private
    def remove_not_allowed_massassignments_recursiv_from(params, attrs=nil)
      params.each do |massassignment_key, value| 
        if params_klasses.any? {|k| value.is_a? k }
          form_columns = attrs || form_columns_for(massassignment_key.to_s)
          attrs = form_columns.select do |item|
            !item.is_a?(Hash)
          end.collect(&:to_s)
          
          nested = (form_columns - attrs).inject({}) do |sum, item|
            sum.merge(item)
          end

          value.reject! do |attr, attr_value|
            attr_name = attr.to_s
            # normale Attribute,
            # date_select attribute
            # oder nested attributes
            !(attrs.include?(attr_name) || 
              attrs.include?(attr_name.gsub(/\([1-6]i\)$/, '')) ||
              !nested[attr.to_s].nil?)
          end

          nested.each do |config_attr, config|
            config.symbolize_keys!
            many_reflection = config[:many_reflection]
            attr_hash = value[config_attr]

            begin
              many_reflection && attr_hash.keys.each {|k| Integer(k) } ||
                !many_reflection && attr_hash.keys.all? {|k| k.match(/[a-z]/) } ||
                raise('not value')
            rescue Exception# => e
              value.delete config_attr
              return
            end
           
            if many_reflection
              attr_hash.values
            else
              [attr_hash]
            end.each do |nested_item|
              remove_not_allowed_massassignments_recursiv_from({:r => nested_item}, config[:columns])
            end
          end
        end
      end
    end

    private
    def form_columns_for(object_name)
      object_name.to_s.split(/[\[\]]/).select do |part| 
        part.present? && !part.match(/^[0-9]+$/)
      end.inject(form_columns) do |sum, part|
        if sum.is_a? Hash
          sum[part] ||= []
        else
          sum.detect do |column|
            column.is_a?(Hash) && column.keys.collect(&:to_sym) == [part.to_sym]
          end[part.to_sym][:columns]
        end
      end
    end
  end
end
