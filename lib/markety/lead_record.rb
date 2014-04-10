module Markety
  # Represents a record of the data known about a lead within marketo
  class LeadRecord
    attr_reader :types

    def initialize(email, idnum = nil, foreignSysPersonId = nil, foreignSysType = nil)
      @idnum      = idnum
      @keyEmail   = email
      @keyForeignSysPersonId = foreignSysPersonId
      @keyForeignSysType = foreignSysType
      @attributes = {}
      @types      = {}
      set_attribute('Email', email)
    end

    # hydrates an instance from a savon hash returned form the marketo API
    def self.from_hash(savon_hash)
      lead_record = LeadRecord.new(savon_hash[:email], savon_hash[:id].to_i)
      savon_hash[:lead_attribute_list][:attribute].each do |attribute|
        lead_record.set_attribute(attribute[:attr_name], attribute[:attr_value], attribute[:attr_type])
      end
      lead_record
    end

    def self.from_hash_list(leads_list)
      results = []

      # savon converts a result set of one into a single hash
      unless leads_list.is_a? Array
        leads_list = [leads_list]
      end

      for savon_hash in leads_list
        lead_record = LeadRecord.new(savon_hash[:email], savon_hash[:id].to_i)
        savon_attribute = savon_hash[:lead_attribute_list][:attribute]
        unless savon_attribute.is_a? Array
          savon_attribute = [savon_attribute]
        end
        savon_attribute.each do |attribute|
          lead_record.set_attribute(attribute[:attr_name], attribute[:attr_value], attribute[:attr_type])
        end
        results << lead_record
      end

      results
    end

    # get the record idnum
    def idnum
      @idnum
    end

    # get the record email
    def email
      get_attribute('Email')
    end

    def keyEmail
      @keyEmail
    end

    # get the record foreignSysPersonId key
    def keyForeignSysPersonId
      @keyForeignSysPersonId
    end

    # get the record foreignSysType key
    def keyForeignSysType
      @keyForeignSysType
    end

    def attributes
      @attributes
    end

    # update the value of the named attribute
    def set_attribute(name, value, type = "string")
      @attributes[name] = value
      @types[name] = type
    end

    # get the value for the named attribute
    def get_attribute(name)
      @attributes[name]
    end

    def get_attribute_type(name)
      @types[name]
    end

    # will yield pairs of |attribute_name, attribute_value|
    def each_attribute_pair(&block)
      @attributes.each_pair do |name, value|
        block.call(name, value)
      end
    end

    def ==(other)
      @attributes == other.attributes &&
      @idnum == other.idnum
    end
  end
end
