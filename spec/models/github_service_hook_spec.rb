# encoding: utf-8
#

require 'spec_helper'

describe GithubServiceHook do
  let(:instance) { Fabricate(:instance) }
  let(:json) do
    data = File.open(File.join(Rails.root, 'spec', 'files', 'github_service_hook', "#{file}.json"), 'r') { |f| f.read }
    data.gsub(/#TICKET#/, ticket_1.identifier).gsub(/#TICKET_2#/, ticket_2.identifier).gsub(/#LOWER_CASE_TICKET#/, ticket_1.identifier.downcase)
  end
  let(:user) do
    u = Fabricate.build(:user, instance: instance)
    u.email_addresses.build(location: EmailAddress::LOCATIONS.key(:home).to_i, address: 'test@example.com')
    u.email_addresses.build(location: EmailAddress::LOCATIONS.key(:work).to_i, address: 'other-test@example.com')
    u.save!
    u
  end
  let(:project) { Fabricate(:project, instance: instance, key: 'TEST') }
  let(:ticket_1) { Fabricate(:ticket, instance: instance, project: project, status: Ticket::STATUSES.key(:open)) }
  let(:ticket_2) { Fabricate(:ticket, instance: instance, project: project, status: Ticket::STATUSES.key(:open)) }
  let(:hook) { GithubServiceHook.new(instance, json) }

  before(:each) { user } # Make sure the user is preloaded.

  context '#simple comment' do
    let(:file) { 'simple_comment' }

    it 'should identify the ticket comment' do
      hook.comments.size.should == 1
    end

    it 'should only find one ticket' do
      hook.comments.first.tickets.size.should == 1
    end

    it 'should set the comment message' do
      hook.comments.first.message.should == 'This is a simple commit comment'
    end

    it 'should identify the files' do
      hook.comments.first.added_files.should == ['test_added.rb']
      hook.comments.first.removed_files.should == ['test_removed.rb']
      hook.comments.first.modified_files.should == ['test_modified.rb']
    end

    it 'should not flag it as a close command' do
      hook.comments.first.close_command.should be_false
    end

    it 'should persist the comment' do
      hook.handle!
      ScmComment.count.should == 1
    end

    it 'should not close the ticket' do
      hook.handle!
      ticket_1.reload
      ticket_1.closed?.should be_false
    end
  end

  context '#alternative email address' do
    let(:file) { 'simple_comment_with_alt_email' }

    it 'should identify the ticket comment' do
      hook.comments.size.should == 1
    end
  end

  context '#invalid email address' do
    let(:file) { 'invalid_author' }

    it 'should not identify any ticket comments' do
      hook.comments.size.should == 0
    end
  end

  context '#invalid ticket' do
    let(:file) { 'invalid_ticket' }

    it 'should not identify any ticket comments' do
      hook.comments.size.should == 0
    end
  end

  context '#multiple ticket references' do
    let(:file) { 'multiple_ticket_references' }

    it 'should identify the ticket comment' do
      hook.comments.size.should == 1
    end

    it 'should refer to two tickets' do
      hook.comments.first.tickets.size.should == 2
    end
  end
  
  context '#multiple tickets' do
    let(:file) { 'multiple_tickets' }

    it 'should identify the ticket comments for two tickets' do
      hook.comments.size.should == 2
    end
  end

  context '#lower case ticket identifier' do
    let(:file) { 'lower_case_ticket' }

    it 'should identify the ticket comment' do
      hook.comments.size.should == 1
    end
  end
  
  context '#close command' do
    let(:file) { 'comment_with_close_command' }

    it 'should identify the ticket comment' do
      hook.comments.size.should == 1
    end

    it 'should set the comment message' do
      hook.comments.first.message.should == 'This is a close commit comment'
    end

    it 'should flag it as a close command' do
      hook.comments.first.close_command.should be_true
    end

    it 'should persist the comment' do
      hook.handle!
      ScmComment.count.should == 1
    end

    it 'should close the ticket' do
      hook.handle!
      ticket_1.reload
      ticket_1.closed?.should be_true
    end
  end
end
