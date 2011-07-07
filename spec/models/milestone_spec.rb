# encoding: utf-8
#

require 'spec_helper'

describe Milestone do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:starts_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:ends_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:closed).of_type(Boolean).with_default_value_of(false) }
    it { should have_field(:closed_at).of_type(DateTime).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:project) }
    it { should have_many(:comments).with_dependent(:destroy) }
    it { should have_many(:tickets).with_dependent(:nullify) }
    it { should embed_one(:ticket_progress) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starts_on) }
    it { should validate_presence_of(:ends_on) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should_not allow_mass_assignment_of(:project) }
    it { should_not allow_mass_assignment_of(:project_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:starts_on) }
    it { should allow_mass_assignment_of(:ends_on) }
    it { should_not allow_mass_assignment_of(:closed) }
    it { should_not allow_mass_assignment_of(:closed_at) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context '#ticket progress' do
    it 'should build a ticket progress when creating milestone' do
      Fabricate(:milestone).ticket_progress.should_not be_blank
    end
  end

  describe '#all comments' do
    let(:instance) { Fabricate(:instance) }

    let(:project) { Fabricate(:project, instance: instance) }

    let(:milestone) do
      Fabricate(:milestone, instance: instance, project: project)
    end
    let(:other_milestone) do
      Fabricate(:milestone, instance: instance, project: project)
    end

    let(:ticket_1) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone) }
    let(:ticket_2) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone) }
    let(:other_ticket) { Fabricate(:ticket, instance: instance, project: project, milestone: other_milestone) }

    it 'should include the comments for the milestone itself' do
      Fabricate(:comment, instance: instance, commentable: milestone)
      milestone.all_comments.size.should == 1
    end

    it 'should not include comments made for other milestones' do
      Fabricate(:comment, instance: instance, commentable: other_milestone)
      milestone.all_comments.size.should == 0
    end

    it 'should include the comments made on tickets' do
      Fabricate(:comment, instance: instance, commentable: ticket_1)
      milestone.all_comments.size.should == 1
    end

    it 'should include the comments made on all tickets' do
      Fabricate(:comment, instance: instance, commentable: ticket_1)
      Fabricate(:comment, instance: instance, commentable: ticket_2)
      milestone.all_comments.size.should == 2
    end

    it 'should not include the comments made on non-related tickets' do
      Fabricate(:comment, instance: instance, commentable: other_ticket)
      milestone.all_comments.size.should == 0
    end
  end

  context '#closing milestone' do
    let(:instance) { Fabricate(:instance) }
    let(:project) { Fabricate(:project, instance: instance) }
    let(:milestone) { Fabricate(:milestone, instance: instance, project: project) }

    let(:open_ticket) { Fabricate(:ticket, project: project, instance: instance, milestone: milestone, status: Ticket::STATUSES.key(:open)) }
    let(:in_progress_ticket) { Fabricate(:ticket, project: project, instance: instance, milestone: milestone, status: Ticket::STATUSES.key(:in_progress)) }
    let(:closed_ticket) { Fabricate(:ticket, project: project, instance: instance, milestone: milestone, status: Ticket::STATUSES.key(:closed)) }

    before(:each) { open_ticket && in_progress_ticket && closed_ticket } # Preload the tickets.

    it 'should remove milestone association from open tickets when closing milestone' do
      open_ticket.milestone.should_not be_blank
      milestone.flag_as_closed!
      open_ticket.reload
      open_ticket.milestone.should be_blank
    end

    it 'should remove milestone association from in-progress tickets when closing milestone' do
      in_progress_ticket.milestone.should_not be_blank
      milestone.flag_as_closed!
      in_progress_ticket.reload
      in_progress_ticket.milestone.should be_blank
    end

    it 'should not remove milestone association from closed tickets when closing milestone' do
      closed_ticket.milestone.should_not be_blank
      milestone.flag_as_closed!
      closed_ticket.reload
      closed_ticket.milestone.should_not be_blank
    end

    it 'should set closed_at when closing milestone' do
      milestone.flag_as_closed!
      milestone.closed_at.should_not be_blank
    end

    it 'should unset closed_at when reopening milestone' do
      milestone.flag_as_closed!
      milestone.restore!
      milestone.closed_at.should be_blank
    end
  end
end
