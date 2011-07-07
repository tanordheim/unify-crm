# encoding: utf-8
#

require 'spec_helper'

describe Project do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:key).of_type(String).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:starts_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:closed).of_type(Boolean).with_default_value_of(false) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should embed_one(:ticket_sequence) }
    it { should belong_to(:instance) }
    it { should belong_to(:organization) }
    it { should belong_to(:category) }
    it { should belong_to(:source) }
    it { should have_many(:comments).with_dependent(:destroy) }
    it { should have_many(:components).with_dependent(:destroy) }
    it { should have_many(:milestones).with_dependent(:destroy) }
    it { should have_many(:tickets).with_dependent(:destroy) }
    it { should embed_one(:ticket_progress) }
    it { should have_many(:pages).with_dependent(:destroy) }
    it { should embed_many(:members) }
    it { should accept_nested_attributes_for(:members) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key).scoped_to(:instance_id) }
    it { should allow_value('foo_bar').for(:key) }
    it { should allow_value('FOOBAR').for(:key) }
    it { should allow_value('foo_1_bar').for(:key) }
    it { should_not allow_value('foo-bar').for(:key) }
    it { should_not allow_value('foo bar').for(:key) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:organization) }
    it { should allow_mass_assignment_of(:organization_id) }
    it { should allow_mass_assignment_of(:category) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:source) }
    it { should allow_mass_assignment_of(:source_id) }
    it { should allow_mass_assignment_of(:members_attributes) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:key) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:starts_on) }
    it { should_not allow_mass_assignment_of(:closed) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#sequence' do
    let(:instance) { Fabricate(:instance) }
    let(:project) { Fabricate(:project, instance: instance) }

    it 'should assign a sequence' do
      project.identifier.should == 10000
    end
  end
  
  context '#ticket sequences' do
    let(:sequence) { Fabricate(:project).ticket_sequence }

    it 'should build a ticket sequence when creating project' do
      sequence.should_not be_blank
    end

    it 'should start model sequence for tickets at 0' do
      sequence.current_value.should == 0
    end
  end

  context '#ticket progress' do
    it 'should build a ticket progress when creating project' do
      Fabricate(:project).ticket_progress.should_not be_blank
    end
  end

  describe '#all comments' do
    let(:instance) { Fabricate(:instance) }

    let(:project) { Fabricate(:project, instance: instance) }
    let(:other_project) { Fabricate(:project, instance: instance) }

    let(:milestone_1) do
      Fabricate(:milestone, instance: instance, project: project)
    end
    let(:milestone_2) do
      Fabricate(:milestone, instance: instance, project: project)
    end
    let(:other_milestone) do
      Fabricate(:milestone, instance: instance)
    end

    let(:ticket_1) { Fabricate(:ticket, instance: instance, project: project) }
    let(:ticket_2) { Fabricate(:ticket, instance: instance, project: project) }
    let(:other_ticket) { Fabricate(:ticket, instance: instance, project: other_project) }

    it 'should include the comments for the project itself' do
      Fabricate(:comment, instance: instance, commentable: project)
      project.all_comments.size.should == 1
    end

    it 'should not include comments made for other projects' do
      Fabricate(:comment, instance: instance, commentable: other_project)
      project.all_comments.size.should == 0
    end

    it 'should include comments made on a milestone' do
      Fabricate(:comment, instance: instance, commentable: milestone_1)
      project.all_comments.size.should == 1
    end

    it 'should include comments made on all milestones' do
      Fabricate(:comment, instance: instance, commentable: milestone_1)
      Fabricate(:comment, instance: instance, commentable: milestone_2)
      project.all_comments.size.should == 2
    end

    it 'should not include comments made on non-related milestones' do
      Fabricate(:comment, instance: instance, commentable: other_milestone)
      project.all_comments.size.should == 0
    end

    it 'should include the comments made on tickets' do
      Fabricate(:comment, instance: instance, commentable: ticket_1)
      project.all_comments.size.should == 1
    end

    it 'should include the comments made on all tickets' do
      Fabricate(:comment, instance: instance, commentable: ticket_1)
      Fabricate(:comment, instance: instance, commentable: ticket_2)
      project.all_comments.size.should == 2
    end

    it 'should not include the comments made on non-related tickets' do
      Fabricate(:comment, instance: instance, commentable: other_ticket)
      project.all_comments.size.should == 0
    end
  end
end
