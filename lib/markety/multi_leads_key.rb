module Markety
  # Encapsulates a key used to look up or describe multiple marketo leads.
  class MultiLeadsKey
    # - *key_type* the type of key to use see LeadKeyType
    # - *key_value* normally a string value for the given type
    def initialize(key_type, key_values)
      @key_type = key_type
      @key_values = key_values
    end

    # get the key type
    def key_type
      @key_type
    end

    # get the key values
    def key_values
      @key_values
    end

    # create a hash from this instance, for sending this object to marketo using savon
    def to_hash
      {
        "keyType" => @key_type,
        "keyValues" => @key_values
      }
    end
  end
end