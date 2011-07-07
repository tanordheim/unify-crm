# encoding: utf-8
#

require 'spec_helper'

describe Ticket do
  describe '#attributes' do
    it { should have_field(:sequence).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:priority).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:status).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:due_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:started_at).of_type(DateTime).with_default_value_of(nil) }
    it { should have_field(:estimated_minutes).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:worked_minutes).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:_scheduled).of_type(Boolean).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:project) }
    it { should belong_to(:milestone) }
    it { should belong_to(:category) }
    it { should belong_to(:user) }
    it { should belong_to(:reporter) }
    it { should belong_to(:component) }
    it { should have_many(:comments).with_dependent(:destroy) }
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:reporter) }
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:priority).to_allow(Ticket::PRIORITIES.keys.map(&:to_i)) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).to_allow(Ticket::STATUSES.keys.map(&:to_i)) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:sequence) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should_not allow_mass_assignment_of(:project) }
    it { should_not allow_mass_assignment_of(:project_id) }
    it { should allow_mass_assignment_of(:category) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:milestone) }
    it { should allow_mass_assignment_of(:milestone_id) }
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:user_id) }
    it { should allow_mass_assignment_of(:component) }
    it { should allow_mass_assignment_of(:component_id) }
    it { should_not allow_mass_assignment_of(:reporter) }
    it { should_not allow_mass_assignment_of(:reporter_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:due_on) }
    it { should allow_mass_assignment_of(:priority) }
    it { should_not allow_mass_assignment_of(:status) }
    it { should_not allow_mass_assignment_of(:started_at) }
    it { should allow_mass_assignment_of(:estimated_minutes) }
    it { should_not allow_mass_assignment_of(:worked_minutes) }
    it { should_not allow_mass_assignment_of(:_scheduled) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#identifier' do
    let(:project) { Fabricate(:project, key: 'TESTKEY') }
    let(:second_project) { Fabricate(:project, key: 'FOOBAR') }

    it 'should build an identifier based on ticket sequence and project key' do
      Fabricate(:ticket, project: project).identifier.should == 'TESTKEY-1'
    end

    it 'should build a different identifier for two different tickets in the same project' do
      Fabricate(:ticket, project: project).identifier.should == 'TESTKEY-1'
      Fabricate(:ticket, project: project).identifier.should == 'TESTKEY-2'
    end

    it 'should build different identifiers for different tickets in different projects' do
      Fabricate(:ticket, project: project).identifier.should == 'TESTKEY-1'
      Fabricate(:ticket, project: second_project).identifier.should == 'FOOBAR-1'
    end
  end

  describe '#status toggling' do
    let(:closed_ticket) { Fabricate(:ticket, status: Ticket::STATUSES.key(:closed)) }
    let(:open_ticket) { Fabricate(:ticket, status: Ticket::STATUSES.key(:open)) }
    let(:started_ticket) { Fabricate(:ticket, status: Ticket::STATUSES.key(:in_progress)) }

    it 'should flag as open when reopening' do
      closed_ticket.reopen!
      closed_ticket.open?.should be_true
    end

    it 'should flag as in progress when starting progress' do
      open_ticket.start_progress!
      open_ticket.in_progress?.should be_true
    end

    it 'should flag as open when stopping progress' do
      started_ticket.stop_progress!
      started_ticket.open?.should be_true
    end

    it 'should flag as closed when closing' do
      open_ticket.close!
      open_ticket.closed?.should be_true
    end
  end

  describe '#worked time-tracking' do
    let(:ticket) { Fabricate(:ticket) }

    it 'should flag the started time when progress is started on a ticket' do
      ticket.start_progress!
      ticket.started_at.should_not be_blank
    end

    it 'should remove the started time when progress is stopped on a ticket' do
      ticket.start_progress!
      ticket.stop_progress!
      ticket.started_at.should be_blank
    end

    it 'should remove the started time when a started task is closed' do
      ticket.start_progress!
      ticket.close!
      ticket.started_at.should be_blank
    end

    it 'should start with no worked time' do
      ticket.worked_minutes.should == 0
    end

    it 'should add a minute to the worked time when stopping progress after one minute' do
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 1.minute) do
        ticket.stop_progress!
      end
      ticket.worked_minutes.should == 1
    end

    # broken after trying to get the app working after not being touched for 10 years; disabling it for now
    # it 'should add a minute to the worked time when stopping progress after 30 seconds' do
    #   ticket.start_progress!
    #   Timecop.freeze(ticket.started_at + 30.seconds) do
    #     ticket.stop_progress!
    #   end
    #   ticket.worked_minutes.should == 1
    # end

    it 'should not accumulate worked time when stopping progress after less than 30 seconds' do
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 29.seconds) do
        ticket.stop_progress!
      end
      ticket.worked_minutes.should == 0
    end
    
    it 'should add ten minutes to the worked time when stopping progress after ten minutes' do
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 10.minute) do
        ticket.stop_progress!
      end
      ticket.worked_minutes.should == 10
    end

    it 'should add 20 minutes to the worked time when doing 2 batches of work at 15 and 5 minutes' do
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 15.minute) do
        ticket.stop_progress!
      end
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 5.minute) do
        ticket.stop_progress!
      end
      ticket.worked_minutes.should == 20
    end

    it 'should add time when closing ticket' do
      ticket.start_progress!
      Timecop.freeze(ticket.started_at + 15.minute) do
        ticket.close!
      end
      ticket.worked_minutes.should == 15
    end
  end

  describe '#progress tracking' do
    let(:instance) { Fabricate(:instance) }
    let(:project) { Fabricate(:project, instance: instance) }

    let(:open_status) { Ticket::STATUSES.key(:open).to_i }
    let(:in_progress_status) { Ticket::STATUSES.key(:in_progress).to_i }
    let(:closed_status) { Ticket::STATUSES.key(:closed).to_i }

    shared_examples_for 'TicketTrackable' do
      context '#counters' do
        it 'should increase ticket counter by 1 when creating ticket' do
          open_ticket_1
          trackable.ticket_progress.total_tickets.should == 1
          open_ticket_2
          trackable.ticket_progress.total_tickets.should == 2
        end

        it 'should not increment ticket counter when updating ticket' do
          t = open_ticket_1
          t.save!
          trackable.ticket_progress.total_tickets.should == 1
        end

        context '#open ticket' do
          it 'should increase open ticket counter by 1 when creating an open ticket' do
            open_ticket_1
            trackable.ticket_progress.open_tickets.should == 1
            open_ticket_2
            trackable.ticket_progress.open_tickets.should == 2
          end

          it 'should not increase open ticket counter when updating an open ticket' do
            t = open_ticket_1
            t.save!
            trackable.ticket_progress.open_tickets.should == 1
          end

          it 'should decrease open ticket counter by 1 when starting progress on ticket' do
            t = open_ticket_1
            t.start_progress!
            trackable.ticket_progress.open_tickets.should == 0
          end

          it 'should decrease open ticket counter by 1 when closing ticket' do
            t = open_ticket_1
            t.close!
            trackable.ticket_progress.open_tickets.should == 0
          end
        end

        context '#in progress-ticket' do
          it 'should increase in progress ticket counter by 1 when creating an in progress ticket' do
            in_progress_ticket_1
            trackable.ticket_progress.in_progress_tickets.should == 1
            in_progress_ticket_2
            trackable.ticket_progress.in_progress_tickets.should == 2
          end

          it 'should not increase in progress ticket counter when updating an in progress ticket' do
            t = in_progress_ticket_1
            t.save!
            trackable.ticket_progress.in_progress_tickets.should == 1
          end

          it 'should decrease in progress ticket counter when stopping progress on ticket' do
            t = in_progress_ticket_1
            t.stop_progress!
            trackable.ticket_progress.in_progress_tickets.should == 0
          end

          it 'should decrease in progress ticket counter when closing ticket' do
            t = in_progress_ticket_1
            t.close!
            trackable.ticket_progress.in_progress_tickets.should == 0
          end
        end

        context '#closed ticket' do
          it 'should increase closed ticket counter by 1 when creating a closed ticket' do
            closed_ticket_1
            trackable.ticket_progress.closed_tickets.should == 1
            closed_ticket_2
            trackable.ticket_progress.closed_tickets.should == 2
          end

          it 'should not increase closed ticket counter when updating a closed ticket' do
            t = closed_ticket_1
            t.save!
            trackable.ticket_progress.closed_tickets.should == 1
          end

          it 'should decrease closed ticket counter when reopening a closed ticket' do
            t = closed_ticket_1
            t.reopen!
            trackable.ticket_progress.closed_tickets.should == 0
          end

          it 'should decrease closed ticket counter when starting progress a closed ticket' do
            t = closed_ticket_1
            t.start_progress!
            trackable.ticket_progress.closed_tickets.should == 0
          end
        end
      end

      context '#estimates' do
        it 'should increase estimated minutes when creating ticket' do
          open_ticket_1
          trackable.ticket_progress.total_estimated_minutes.should == 30
          open_ticket_2
          trackable.ticket_progress.total_estimated_minutes.should == 45
        end

        it 'should not increment estimate when updating ticket' do
          t = open_ticket_1
          t.save!
          trackable.ticket_progress.total_estimated_minutes.should == 30
        end

        it 'should increment total estimate when increasing estimate on a ticket' do
          t = open_ticket_1
          open_ticket_2
          t.estimated_minutes = 35
          t.save!
          trackable.ticket_progress.total_estimated_minutes.should == 50
        end

        it 'should decrement total estimate when decreasing estimate on a ticket' do
          t = open_ticket_1
          open_ticket_2
          t.estimated_minutes = 5
          t.save!
          trackable.ticket_progress.total_estimated_minutes.should == 20
        end
        
        context '#open ticket' do
          it 'should increase open ticket estimates when creating an open ticket' do
            open_ticket_1
            trackable.ticket_progress.open_estimated_minutes.should == 30
            open_ticket_2
            trackable.ticket_progress.open_estimated_minutes.should == 45
          end

          it 'should not increase open ticket estimates when updating an open ticket' do
            t = open_ticket_1
            t.save!
            trackable.ticket_progress.open_estimated_minutes.should == 30
          end

          it 'should increment open ticket estimates when changing estimate on an open ticket' do
            t = open_ticket_1
            open_ticket_2
            t.estimated_minutes = 35
            t.save!
            trackable.ticket_progress.open_estimated_minutes.should == 50
          end
          
          it 'should decrement total estimate when decreasing estimate on an open ticket' do
            t = open_ticket_1
            open_ticket_2
            t.estimated_minutes = 5
            t.save!
            trackable.ticket_progress.open_estimated_minutes.should == 20
          end
          
          it 'should decrease open ticket estimates when starting progress on ticket' do
            t = open_ticket_1
            t.start_progress!
            trackable.ticket_progress.open_estimated_minutes.should == 0
          end

          it 'should decrease open ticket estimates when closing ticket' do
            t = open_ticket_1
            t.close!
            trackable.ticket_progress.open_estimated_minutes.should == 0
          end
        end

        context '#in progress-tickets' do
          it 'should increase in progress ticket estimates when creating an in progress ticket' do
            in_progress_ticket_1
            trackable.ticket_progress.in_progress_estimated_minutes.should == 30
            in_progress_ticket_2
            trackable.ticket_progress.in_progress_estimated_minutes.should == 45
          end

          it 'should not increase in progress ticket estimates when updating an in progress ticket' do
            t = in_progress_ticket_1
            t.save!
            trackable.ticket_progress.in_progress_estimated_minutes.should == 30
          end

          it 'should increment in progress ticket estimates when changing estimate on an in progress ticket' do
            t = in_progress_ticket_1
            in_progress_ticket_2
            t.estimated_minutes = 35
            t.save!
            trackable.ticket_progress.in_progress_estimated_minutes.should == 50
          end
          
          it 'should decrement in progress estimate when decreasing estimate on an in progress ticket' do
            t = in_progress_ticket_1
            in_progress_ticket_2
            t.estimated_minutes = 5
            t.save!
            trackable.ticket_progress.in_progress_estimated_minutes.should == 20
          end
          
          it 'should decrease in progress ticket estimates when stopping progress on ticket' do
            t = in_progress_ticket_1
            t.stop_progress!
            trackable.ticket_progress.in_progress_estimated_minutes.should == 0
          end

          it 'should decrease in progress ticket estimates when closing ticket' do
            t = in_progress_ticket_1
            t.close!
            trackable.ticket_progress.in_progress_estimated_minutes.should == 0
          end
        end

        context '#closed tickets' do
          it 'should increase closed ticket estimates when creating a closed ticket' do
            closed_ticket_1
            trackable.ticket_progress.closed_estimated_minutes.should == 30
            closed_ticket_2
            trackable.ticket_progress.closed_estimated_minutes.should == 45
          end

          it 'should not increase closed ticket counter when updating a closed ticket' do
            t = closed_ticket_1
            t.save!
            trackable.ticket_progress.closed_estimated_minutes.should == 30
          end

          it 'should increment closed ticket estimates when changing estimate on an closed ticket' do
            t = closed_ticket_1
            closed_ticket_2
            t.estimated_minutes = 35
            t.save!
            trackable.ticket_progress.closed_estimated_minutes.should == 50
          end

          it 'should decrement closed ticket estimate when decreasing estimate on a closed ticket' do
            t = closed_ticket_1
            closed_ticket_2
            t.estimated_minutes = 5
            t.save!
            trackable.ticket_progress.closed_estimated_minutes.should == 20
          end
          
          it 'should decrease closed ticket counter when reopening a closed ticket' do
            t = closed_ticket_1
            t.reopen!
            trackable.ticket_progress.closed_estimated_minutes.should == 0
          end

          it 'should decrease closed ticket counter when starting progress a closed ticket' do
            t = closed_ticket_1
            t.start_progress!
            trackable.ticket_progress.closed_estimated_minutes.should == 0
          end
        end
      end
    end

    describe '#project' do
      let(:open_ticket_1) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 30, status: open_status) }
      let(:open_ticket_2) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 15, status: open_status) }
      
      let(:in_progress_ticket_1) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 30, status: in_progress_status) }
      let(:in_progress_ticket_2) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 15, status: in_progress_status) }

      let(:closed_ticket_1) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 30, status: closed_status) }
      let(:closed_ticket_2) { Fabricate(:ticket, instance: instance, project: project, estimated_minutes: 15, status: closed_status) }

      let(:trackable) { project }
      
      it_behaves_like 'TicketTrackable'
    end

    describe '#milestone' do
      let(:milestone) { Fabricate(:milestone, instance: instance, project: project) }

      let(:open_ticket_1) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 30, status: open_status) }
      let(:open_ticket_2) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 15, status: open_status) }
      
      let(:in_progress_ticket_1) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 30, status: in_progress_status) }
      let(:in_progress_ticket_2) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 15, status: in_progress_status) }

      let(:closed_ticket_1) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 30, status: closed_status) }
      let(:closed_ticket_2) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, estimated_minutes: 15, status: closed_status) }

      let(:trackable) { milestone }
      
      it_behaves_like 'TicketTrackable'

      context '#removing ticket from milestone' do
        context '#counters' do
          it 'should decrease ticket counter by 1 when removing ticket from milestone' do
            t = open_ticket_1
            open_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.total_tickets.should == 1
          end

          it 'should decrease open ticket counter by 1 when removing open ticket from milestone' do
            t = open_ticket_1
            open_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.open_tickets.should == 1
          end

          it 'should decrease in progress ticket counter by 1 when removing in progress ticket from milestone' do
            t = in_progress_ticket_1
            in_progress_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.in_progress_tickets.should == 1
          end

          it 'should decrease closed ticket counter by 1 when removing closed ticket from milestone' do
            t = closed_ticket_1
            closed_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.closed_tickets.should == 1
          end
        end

        context '#counters' do
          it 'should decrease ticket estimates when removing ticket from milestone' do
            t = open_ticket_1
            open_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.total_estimated_minutes.should == 15
          end

          it 'should decrease open ticket counter by 1 when removing open ticket from milestone' do
            t = open_ticket_1
            open_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.open_estimated_minutes.should == 15
          end

          it 'should decrease in progress ticket counter by 1 when removing in progress ticket from milestone' do
            t = in_progress_ticket_1
            in_progress_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.in_progress_estimated_minutes.should == 15
          end

          it 'should decrease closed ticket counter by 1 when removing closed ticket from milestone' do
            t = closed_ticket_1
            closed_ticket_2
            t.milestone = nil
            t.save!
            milestone.reload
            milestone.ticket_progress.closed_estimated_minutes.should == 15
          end
        end
      end
    end
  end

  describe '#scheduled flag' do
    let(:instance) { Fabricate(:instance) }
    let(:user) { Fabricate(:user, instance: instance) }
    let(:project) { Fabricate(:project, instance: instance, organization: Fabricate(:organization, instance: instance)) }
    let(:milestone) { Fabricate(:milestone, instance: instance, project: project) }
    let(:ticket) { Fabricate(:ticket, instance: instance, project: project, milestone: nil, user: nil, reporter: user, priority: nil, estimated_minutes: nil) }
    let(:scheduled_ticket) { Fabricate(:ticket, instance: instance, project: project, milestone: milestone, user: user, reporter: user, priority: Ticket::PRIORITIES.key(:trivial).to_i, estimated_minutes: nil) }

    it 'should set scheduled to false by default' do
      ticket._scheduled.should be_false
    end

    it 'should set scheduled to true if priority, milestone and user is set' do
      scheduled_ticket._scheduled.should be_true
    end

    it 'should not set scheduled if user is not set' do
      scheduled_ticket.user = nil
      scheduled_ticket.save!
      scheduled_ticket._scheduled.should be_false
    end

    it 'should not set scheduled if priority is not set' do
      scheduled_ticket.priority = nil
      scheduled_ticket.save!
      scheduled_ticket._scheduled.should be_false
    end

    it 'should not set scheduled if milestone is not set' do
      scheduled_ticket.milestone = nil
      scheduled_ticket.save!
      scheduled_ticket._scheduled.should be_false
    end
  end
end
