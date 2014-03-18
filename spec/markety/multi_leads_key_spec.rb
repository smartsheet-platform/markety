require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Markety
  describe LeadKey do
    it "should store type and values on construction" do
      KEY_VALUES = ['a value', 'another value']
      KEY_TYPE = LeadKeyType::IDNUM
      lead_key = MultiLeadsKey.new(KEY_TYPE, KEY_VALUES)
      lead_key.key_type.should == KEY_TYPE
      lead_key.key_values.should == KEY_VALUES
    end

    it "should to_hash correctly" do
      KEY_VALUES = ['a value', 'another value']
      KEY_TYPE = LeadKeyType::IDNUM
      lead_key = MultiLeadsKey.new(KEY_TYPE, KEY_VALUES)

      lead_key.to_hash.should == {
          "keyType" => KEY_TYPE,
          "keyValues" => KEY_VALUES
      }
    end
  end
end