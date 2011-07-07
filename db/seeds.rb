# encoding: utf-8

# Clear the data in the database
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

puts "Creating core data..."

# Create a test instance.
instance = Instance.create!(subdomain: 'test', organization_attributes: { name: 'Test Organization' })

# Create some test users.
test_user = instance.users.create!(username: 'test', password: 'secret', password_confirmation: 'secret', first_name: 'Test', last_name: 'User', title: 'End Boss')

# Create some event categories.
%w(Call E-mail Follow-up Meeting).each do |name|
  Fabricate(:event_category, instance: instance, name: name)
end

# Create some deal categories.
%w(Copywriting Print Strategy Design).each do |name|
  Fabricate(:deal_category, instance: instance, name: name)
end

# Create some project categories.
%w(Copywriting Print Design).each do |name|
  Fabricate(:project_category, instance: instance, name: name)
end

# Create some ticket categories.
%w(Bug Issue Story).each do |name|
  Fabricate(:ticket_category, instance: instance, name: name)
end

# Create some sources.
%w(Call Import Referral Website).each do |name|
  Fabricate(:source, instance: instance, name: name)
end

# Create some deal stages.
puts "Creating deal stages..."
Fabricate(:deal_stage, instance: instance, name: 'Lost', percentage: 0)
Fabricate(:deal_stage, instance: instance, name: 'Qualified Lead', percentage: 10)
Fabricate(:deal_stage, instance: instance, name: 'Request for Info', percentage: 25)
Fabricate(:deal_stage, instance: instance, name: 'Presentation', percentage: 50)
Fabricate(:deal_stage, instance: instance, name: 'Negotiation', percentage: 70)
Fabricate(:deal_stage, instance: instance, name: 'Won', percentage: 100)

unless ENV['EMPTY_DB']
  # Create some test organizations.
  puts "Creating organizations..."
  3.times do

    source = rand(1..10) > 3 ? Source.all.to_a.sample : nil
    o = Fabricate.build(:organization, instance: instance, source: source)
    rand(0..2).times do
      Fabricate.build(:phone_number, phoneable: o)
    end
    rand(0..2).times do
      Fabricate.build(:email_address, emailable: o)
    end
    rand(0..2).times do
      Fabricate.build(:website, websiteable: o)
    end
    rand(0..2).times do
      Fabricate.build(:instant_messenger, instant_messageable: o)
    end
    rand(0..2).times do
      Fabricate.build(:twitter_account, tweetable: o)
    end
    rand(0..2).times do
      Fabricate.build(:address, addressable: o)
    end
    o.save!

    # Create some comments for the organization.
    rand(0..5).times do
      Fabricate(:comment, instance: instance, commentable: o, user: test_user)
    end

  end

  organizations = Organization.all.to_a

  # Create some test people.
  puts "Creating people..."
  10.times do

    source = rand(1..10) > 3 ? Source.all.to_a.sample : nil
    p = Fabricate(:person, instance: instance, source: source)
    rand(0..2).times do
      Fabricate.build(:phone_number, phoneable: p)
    end
    rand(0..2).times do
      Fabricate.build(:email_address, emailable: p)
    end
    rand(0..2).times do
      Fabricate.build(:website, websiteable: p)
    end
    rand(0..2).times do
      Fabricate.build(:instant_messenger, instant_messageable: p)
    end
    rand(0..2).times do
      Fabricate.build(:twitter_account, tweetable: p)
    end
    rand(0..2).times do
      Fabricate.build(:address, addressable: p)
    end

    # Employ the person in some organizations.
    employed_in = organizations.sample(rand(1..5))
    employed_in.each do |org|
      Fabricate.build(:employment, person: p, organization: org)
    end

    p.save!

    # Create some comments for the person.
    rand(0..5).times do
      Fabricate(:comment, instance: instance, commentable: p, user: test_user)
    end
    
  end

  # Create some events.
  puts "Creating events..."
  people = Person.all.to_a
  event_time = Time.now.beginning_of_day + 8.hours
  10.times do
    category = rand(1..10) > 3 ? EventCategory.all.to_a.sample : nil
    event = Fabricate.build(:event, instance: instance, starts_at: event_time, ends_at: event_time + [15, 30, 45, 60].sample.minutes)
    event.assignees = [Fabricate.build(:event_assignee, event: event, user: test_user)]
    event.save!
    event_time = event_time + rand(1..5).hours + [0, 15, 30, 45, 60].sample.minutes
  end

  # Create some deals.
  puts "Creating deals..."
  5.times do

    category = rand(1..10) > 3 ? DealCategory.all.to_a.sample : nil
    source = rand(1..10) > 3 ? Source.all.to_a.sample : nil
    d = Fabricate(:deal, instance: instance, organization: instance.contacts.organizations.to_a.sample, person: instance.contacts.people.to_a.sample, stage: DealStage.all.to_a.sample, expecting_close_on: Date.today + rand(1..25).days, category: category, source: source)

    # Create some comments for the deal.
    rand(0..5).times do
      Fabricate(:comment, instance: instance, commentable: d, user: test_user)
    end

  end

  # Create some projects.
  puts "Creating projects..."
  5.times do

    category = rand(1..10) > 3 ? ProjectCategory.all.to_a.sample : nil
    source = rand(1..10) > 3 ? Source.all.to_a.sample : nil
    p = Fabricate(:project, instance: instance, organization: instance.contacts.organizations.to_a.sample, category: category, source: source, starts_on: Date.today + rand(0..11).months + rand(1..30).days)

    # Create some comments for the project.
    rand(0..5).times do
      Fabricate(:comment, instance: instance, commentable: p, user: test_user)
    end

    # Create some milestones for the project.
    rand(1..5).times do

      m = Fabricate(:milestone, instance: instance, project: p)

      # Create some comments for the milestone.
      rand(0..5).times do
        c = Fabricate(:comment, instance: instance, commentable: m, user: test_user)
      end

    end

    # Create some tickets for the project.
    milestones = p.milestones.to_a
    5.times do

      milestone = rand(1..10) > 3 ? milestones.sample : nil
      t = Fabricate(:ticket, instance: instance, project: p, milestone: milestone, category: TicketCategory.all.to_a.sample, user: test_user, reporter: test_user)

      # Create some comments for the ticket.
      rand(0..5).times do
        if rand(1..10) > 5
          Fabricate(:comment, instance: instance, commentable: t, user: test_user)
        else

          c = Fabricate.build(:scm_comment, instance: instance, commentable: t, user: test_user)
          rand(1..5).times do
            Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:add).to_i)
          end
          rand(1..5).times do
            Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:change).to_i)
          end
          rand(1..5).times do
            Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:remove).to_i)
          end
          c.save!

        end
      end

    end

    # Create some pages for the project.
    rand(0..5).times do
      Fabricate(:page, instance: instance, project: p)
    end
    
  end

  puts "Creating default invoicing data..."

  # Create some tax codes
  account_2700 = Fabricate(:account, instance: instance, number: 2700, name: 'Utgående merverdiavgift, høy sats', type: Account::TYPES.key(:passiva).to_i)
  account_2710 = Fabricate(:account, instance: instance, number: 2710, name: 'Inngående merverdiavgift, høy sats', type: Account::TYPES.key(:passiva).to_i)
  tax_code_1 = Fabricate(:tax_code, instance: instance, code: 1, name: 'Fradrag for inngående avgift', percentage: 25, target_account: account_2710)
  tax_code_3 = Fabricate(:tax_code, instance: instance, code: 3, name: 'Utgående avgift', percentage: 25, target_account: account_2700)

  # Create some accounting accounts
  account_1920 = Fabricate(:account, instance: instance, number: 1920, name: 'Bankinnskudd', type: Account::TYPES.key(:balance).to_i)
  account_3000 = Fabricate(:account, instance: instance, number: 3000, name: 'Salgsinntakter, uttak, avg. pliktig', type: Account::TYPES.key(:income).to_i, tax_code: tax_code_3)

  # Create some payment forms
  payment_form_1920 = Fabricate(:payment_form, instance: instance, account: account_1920, name: 'Bankinnskudd')

  # Create some products
  test_product = Fabricate(:product, instance: instance, key: 'TEST', name: 'Test Product', price: 150, account: account_3000)

  # Create some invoices.
  puts "Creating invoices..."
  invoice_1 = Fabricate.build(:invoice, instance: instance, organization: Organization.all.to_a.sample, state: Invoice::STATES.key(:draft).to_i, lines: [])
  rand(1..5).times do
    invoice_1.lines << Fabricate.build(:invoice_line, invoice: nil, product: test_product)
  end
  invoice_1.save!

  invoice_2 = Fabricate.build(:invoice, instance: instance, organization: Organization.all.to_a.sample, state: Invoice::STATES.key(:draft).to_i, lines: [])
  rand(1..5).times do
    invoice_2.lines << Fabricate.build(:invoice_line, invoice: nil, product: test_product)
  end
  invoice_2.save!
  
  invoice_3 = Fabricate.build(:invoice, instance: instance, organization: Organization.all.to_a.sample, state: Invoice::STATES.key(:draft).to_i, lines: [])
  rand(1..5).times do
    invoice_3.lines << Fabricate.build(:invoice_line, invoice: nil, product: test_product)
  end
  invoice_3.save!

  # Generate the two first invoices.
  puts "Generating invoices..."
  invoice_1.generate!
  invoice_2.generate!
  
end
