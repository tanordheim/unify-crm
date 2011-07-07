# encoding: utf-8
#

require 'spec_helper'

describe TicketProgress do
  describe '#attributes' do
    it { should have_field(:total_tickets).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:open_tickets).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:in_progress_tickets).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:closed_tickets).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:total_estimated_minutes).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:open_estimated_minutes).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:in_progress_estimated_minutes).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:closed_estimated_minutes).of_type(Integer).with_default_value_of(0) }
  end

  describe '#associations' do
    it { should be_embedded_in(:ticket_trackable) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end
end
