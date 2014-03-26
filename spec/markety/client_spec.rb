require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Markety

  describe Client do
    EMAIL   = "some@email.com"
    IDNUM   = 29
    FIRST   = 'Joe'
    LAST    = 'Smith'
    COMPANY = 'A Company'
    MOBILE  = '415 123 456'
    API_KEY = 'API123KEY'

    context 'Client interaction' do
      it "should have the correct body format on get_lead_by_idnum" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Markety::Client.new(savon_client, authentication_header)
        response_hash         = {
            :success_get_lead => {
                :result => {
                    :count            => 1,
                    :lead_record_list => {
                        :lead_record => {
                            :email                 => EMAIL,
                            :lead_attribute_list   => {
                                :attribute => [
                                    {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                    {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                    {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                    {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                                ]
                            },
                            :foreign_sys_type      => nil,
                            :foreign_sys_person_id => nil,
                            :id                    => IDNUM.to_s
                        }
                    }
                }
            }
        }
        expect_request(savon_client,
                       authentication_header,
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        client.get_lead_by_idnum(IDNUM).should == expected_lead_record
      end

      it "should have the correct body format on get_lead_by_email" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Markety::Client.new(savon_client, authentication_header)
        response_hash         = {
            :success_get_lead => {
                :result => {
                    :count            => 1,
                    :lead_record_list => {
                        :lead_record => {
                            :email                 => EMAIL,
                            :lead_attribute_list   => {
                                :attribute => [
                                    {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                    {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                    {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                    {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                                ]
                            },
                            :foreign_sys_type      => nil,
                            :foreign_sys_person_id => nil,
                            :id                    => IDNUM.to_s
                        }
                    }
                }
            }
        }
        expect_request(savon_client,
                       authentication_header,
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        client.get_lead_by_email(EMAIL).should == expected_lead_record
      end

      it "should have the correct body format on sync_lead_record" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Markety::Client.new(savon_client, authentication_header)
        response_hash         = {
            :success_sync_lead => {
                :result => {
                    :lead_id     => IDNUM,
                    :sync_status => {
                        :error   => nil,
                        :status  => 'UPDATED',
                        :lead_id => IDNUM
                    },
                    :lead_record => {
                        :email                 => EMAIL,
                        :lead_attribute_list   => {
                            :attribute => [
                                {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                            ]
                        },
                        :foreign_sys_type      => nil,
                        :foreign_sys_person_id => nil,
                        :id                    => IDNUM.to_s
                    }
                }
            }
        }
        expect_request(savon_client,
                       authentication_header,
                       response_hash)
        lead_record = LeadRecord.new(EMAIL, IDNUM)
        lead_record.set_attribute('name1', 'val1')
        lead_record.set_attribute('name2', 'val2')
        lead_record.set_attribute('name3', 'val3')
        lead_record.set_attribute('name4', 'val4')

        client.sync_lead_record(lead_record).should == lead_record
      end

      it "should have the correct body format on sync_multiple_lead_records" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Markety::Client.new(savon_client, authentication_header)
        response_hash         = {
          :success_sync_multiple_leads => {
            :result => {
              :sync_status_list => {
                :sync_status => [
                  {
                    :error   => nil,
                    :status  => 'UPDATED',
                    :lead_id => IDNUM
                  },
                  {
                    :error   => nil,
                    :status  => 'UPDATED',
                    :lead_id => IDNUM + 1
                  }
                ]
              }
            }
          }
        }
        expect_request(savon_client,
                       authentication_header,
                       response_hash)
        lead_record = LeadRecord.new(EMAIL, IDNUM)
        lead_record2 = LeadRecord.new("foo." + EMAIL, IDNUM + 1)

        response = client.sync_multiple_lead_records([lead_record, lead_record2])
        response[:sync_status].size.should == 2
        response[:sync_status][0][:status].should == "UPDATED"
        response[:sync_status][1][:status].should == "UPDATED"

      end

      it "should have the correct body format on sync_lead" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Markety::Client.new(savon_client, authentication_header)
        response_hash         = {
            :success_sync_lead => {
                :result => {
                    :lead_id     => IDNUM,
                    :sync_status => {
                        :error   => nil,
                        :status  => 'UPDATED',
                        :lead_id => IDNUM
                    },
                    :lead_record => {
                        :email                 => EMAIL,
                        :lead_attribute_list   => {
                            :attribute => [
                                {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                            ]
                        },
                        :foreign_sys_type      => nil,
                        :foreign_sys_person_id => nil,
                        :id                    => IDNUM.to_s
                    }
                }
            }
        }

        expect_request(savon_client,
                       authentication_header,
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        client.sync_lead(EMAIL, FIRST, LAST, COMPANY, MOBILE).should == expected_lead_record
      end

      context "list operations" do
        LIST_KEY = 'awesome leads list'

        before(:each) do
          @savon_client          = double('savon_client')
          @authentication_header = double('authentication_header')
          @client                = Markety::Client.new(@savon_client, @authentication_header)
        end

        it "should have the correct body format on add_to_list" do
          response_hash = {
            :success_list_operation => {
              :result => {
                :success => true,
                :status_list => nil
              }
            }
          }
          expect_request(@savon_client,
                         @authentication_header,
                         response_hash)

          @client.add_to_list(LIST_KEY, IDNUM).should == true
        end

        it "should have the correct body format on remove_from_list" do
          response_hash = {
            :success_list_operation => {
              :result => {
                :success => true,
                :status_list => nil
              }
            }
          }
          expect_request(@savon_client,
                         @authentication_header,
                         response_hash)

          @client.remove_from_list(LIST_KEY, IDNUM).should == true
        end

        it "should have the correct body format on is_member_of_list?" do
          response_hash = {
            :success_list_operation => {
              :result => {
                :success => true,
                :status_list => {
                  :lead_status => {
                    :lead_key => {
                      :key_type => IDNUM,
                      :key_value => 1
                    },
                    :status => true
                  }
                }
              }
            }
          }
          expect_request(@savon_client,
                         @authentication_header,
                         response_hash)

          @client.is_member_of_list?(LIST_KEY, IDNUM).should == true
        end
      end
    end

    private

    def equals_matcher(expected)
      Proc.new { |actual|
        actual.should == expected
      }
    end

    def expect_request(savon_client, authentication_header, response_hash)
      header_hash       = double('header_hash')
      soap_response     = double('soap_response')

      authentication_header.should_receive(:set_time)
      authentication_header.should_receive(:to_hash).and_return(header_hash)

      soap_response.should_receive(:to_hash).and_return(response_hash)
      savon_client.should_receive(:call).and_return(soap_response)
    end
  end

  describe ListOperationType do
    it 'should define the correct types' do
      ListOperationType::ADD_TO.should == 'ADDTOLIST'
      ListOperationType::IS_MEMBER_OF.should == 'ISMEMBEROFLIST'
      ListOperationType::REMOVE_FROM.should == 'REMOVEFROMLIST'
    end
  end
end