# vim: ft=ruby
stroke_bounds = false

prawn_document(:filename => "invoice-f90-#{invoice.identifier}.pdf", :force_download => true, :page_size => 'A4', :margin => 0) do |pdf|

  prawn_configure_fonts(pdf)

  pdf.font 'Arial'
  pdf.default_leading 2
  pdf.font_size 10

  # Build the company address block
  pdf.bounding_box [40, 775], :width => 260, :height => 50 do

    pdf.stroke_bounds if stroke_bounds

    pdf.font_size 12
    pdf.text invoice.biller_name, :style => :bold
    pdf.font_size 10
    unless invoice.biller_street_name.blank?
      pdf.text invoice.biller_street_name
    end

    zip_code_and_city = []
    zip_code_and_city << invoice.biller_zip_code unless invoice.biller_zip_code.blank?
    zip_code_and_city << invoice.biller_city unless invoice.biller_city.blank?
    unless zip_code_and_city.empty?
      pdf.text zip_code_and_city.join(' ')
    end

  end

  # Build the billing information block
  pdf.bounding_box [395, 775], :width => 175, :height => 50 do

    pdf.stroke_bounds if stroke_bounds

    table_data = []

    unless invoice.biller_vat_number.blank?
      table_data << [
        prawn_left_cell(pdf, 'Org.nr', :font_style => :bold), prawn_right_cell(pdf, invoice.biller_vat_number)
      ]
    end

    unless invoice.biller_bank_account_number.blank?
      table_data << [
        prawn_left_cell(pdf, 'Girokonto', :font_style => :bold), prawn_right_cell(pdf, invoice.biller_bank_account_number)
      ]
    end

    pdf.font_size 8
    pdf.table(table_data, :width => 175, :cell_style => { :borders => [], :padding => [2, 0, 0, 0] }) unless table_data.empty?
    pdf.font_size 10

  end

  # Build the organization information block
  pdf.bounding_box [40, 720], :width => 265, :height => 70 do

    pdf.stroke_bounds if stroke_bounds

    pdf.font_size 12
    pdf.text invoice.organization_name, :style => :bold
    pdf.font_size 10

    unless invoice.organization_street_name.blank?
      pdf.text invoice.organization_street_name
    end
    
    zip_code_and_city = []
    zip_code_and_city << invoice.organization_zip_code unless invoice.organization_zip_code.blank?
    zip_code_and_city << invoice.organization_city unless invoice.organization_city.blank?
    unless zip_code_and_city.empty?
      pdf.text zip_code_and_city.join(' ')
    end

  end

  # Build the invoice information block
  pdf.bounding_box [395, 720], :width => 175, :height => 95 do

    pdf.stroke_bounds if stroke_bounds

    pdf.font_size 12
    if invoice.total_cost < 0
      pdf.text "Kreditnota", :style => :bold
    else
      pdf.text "Faktura", :style => :bold
    end
    pdf.font_size 10

    pdf.move_up 1
    table_data = []
    table_data << [
      prawn_left_cell(pdf, 'Kundenr', :font_style => :bold), prawn_right_cell(pdf, invoice.organization_identifier)
    ]
    table_data << [
      prawn_left_cell(pdf, 'Fakturanr', :font_style => :bold), prawn_right_cell(pdf, invoice.identifier)
    ]
    table_data << [
      prawn_left_cell(pdf, 'Fakturadato', :font_style => :bold), prawn_right_cell(pdf, invoice.billed_on.strftime('%d.%m.%Y'))
    ]
    table_data << [
      prawn_left_cell(pdf, 'Forfallsdato', :font_style => :bold), prawn_right_cell(pdf, invoice.due_on.strftime('%d.%m.%Y'))
    ]

    unless invoice.project_key.blank?
      table_data << [
        prawn_left_cell(pdf, 'Prosjektkode', :font_style => :bold), prawn_right_cell(pdf, invoice.project_key)
      ]
    end

    unless invoice.biller_reference.blank?
      table_data << [
        prawn_left_cell(pdf, 'Vår ref.', :font_style => :bold), prawn_right_cell(pdf, invoice.biller_reference)
      ]
    end

    unless invoice.organization_reference.blank?
      table_data << [
        prawn_left_cell(pdf, 'Deres ref.', :font_style => :bold), prawn_right_cell(pdf, invoice.organization_reference)
      ]
    end
    
    pdf.font_size 8
    pdf.table(table_data, :width => 175, :cell_style => { :borders => [], :padding => [2, 0, 0, 0] })
    pdf.font_size 10

  end

  # Add the invoice lines

  # Prepare the data for the invoice lines
  lines_data = []

  # Add column headers
  lines_data << [
    prawn_left_cell(pdf, 'Varenr', :width => 80, :font_style => :bold),
    prawn_left_cell(pdf, 'Beskrivelse', :font_style => :bold),
    prawn_right_cell(pdf, 'Pris', :width => 80, :font_style => :bold),
    prawn_right_cell(pdf, 'Antall', :width => 40, :font_style => :bold),
    prawn_right_cell(pdf, 'MVA', :width => 40, :font_style => :bold),
    prawn_right_cell(pdf, 'Netto', :width => 80, :font_style => :bold)
  ]

  # Add the invoice lines
  invoice.lines.each do |line|

    tax_percentage = "#{line.tax_percentage}%"

    lines_data << [
      prawn_left_cell(pdf, line.product_key),
      prawn_left_cell(pdf, line.description),
      prawn_right_cell(pdf, format_currency(line.price_per), :width => 80),
      prawn_right_cell(pdf, line.quantity, :width => 40),
      prawn_right_cell(pdf, tax_percentage, :width => 40),
      prawn_right_cell(pdf, format_currency(line.net_cost), :width => 80)
    ]

  end

  pdf.bounding_box [40, 600], :width => 530, :height => 260 do

    pdf.stroke_bounds if stroke_bounds

    pdf.table(lines_data, :width => 530, :cell_style => { :borders => [], :padding => [2, 5] })

  end

  # Add the invoice line summary
  pdf.bounding_box [40, 340], :width => 530, :height => 40 do

    pdf.stroke_bounds if stroke_bounds

    summary_data = []

    # Build the table headers
    summary_headers = [[
      prawn_left_cell(pdf, ''),
      prawn_right_cell(pdf, 'Nettosalg', :width => 100, :font_style => :bold),
      prawn_right_cell(pdf, 'Avg. pliktig', :width => 100, :font_style => :bold),
      prawn_right_cell(pdf, 'MVA', :width => 100, :font_style => :bold),
      prawn_right_cell(pdf, 'TOTALT', :width => 100, :font_style => :bold)
    ]]

    # Build the summary records
    summary_data = [[
      prawn_left_cell(pdf, ''),
      prawn_right_cell(pdf, String.new(format_currency(invoice.net_cost)), :width => 100),
      prawn_right_cell(pdf, String.new(format_currency(invoice.taxable_amount)), :width => 100),
      prawn_right_cell(pdf, String.new(format_currency(invoice.tax_cost)), :width => 100),
      prawn_right_cell(pdf, String.new(format_currency(invoice.total_cost)), :width => 100, :font_style => :bold)
    ]]

    pdf.table(summary_headers, :width => 530, :cell_style => { :borders => [], :padding => [2, 5] })
    pdf.table(summary_data, :width => 530, :cell_style => { :borders => [], :padding => [2, 5] })

  end

  # Add receipt amount
  pdf.bounding_box [232, 260], :width => 60, :height => 10 do
    pdf.stroke_bounds if stroke_bounds
    pdf.text String.new(format_currency(invoice.total_cost))
  end

  # Add recipt account number
  pdf.bounding_box [41, 260], :width => 100, :height => 10 do
    pdf.stroke_bounds if stroke_bounds
    pdf.text invoice.biller_bank_account_number unless invoice.biller_bank_account_number.blank?
  end

  # Add payment information
  pdf.bounding_box [42, 220], :width => 220, :height => 60 do

    pdf.stroke_bounds if stroke_bounds

    table_data = []
    table_data << [
      prawn_left_cell(pdf, 'Kundenr:'), prawn_right_cell(pdf, invoice.organization_identifier)
    ]
    table_data << [
      prawn_left_cell(pdf, 'Fakturanr:'), prawn_right_cell(pdf, invoice.identifier)
    ]

    pdf.table(table_data, :cell_style => { :borders => [], :padding => [2, 0, 0, 0] })
    
  end

  # Due date information
  pdf.bounding_box [480, 230], :width => 70, :height => 10 do
    pdf.stroke_bounds if stroke_bounds
    pdf.text invoice.due_on.strftime('%d.%m.%Y')
  end

  # Add paid by-information
  pdf.bounding_box [42, 130], :width => 220, :height => 45 do

    pdf.stroke_bounds if stroke_bounds

    pdf.text invoice.organization_name
    unless invoice.organization_street_name.blank?
      pdf.text invoice.organization_street_name
    end
    
    zip_code_and_city = []
    zip_code_and_city << invoice.organization_zip_code unless invoice.organization_zip_code.blank?
    zip_code_and_city << invoice.organization_city unless invoice.organization_city.blank?
    unless zip_code_and_city.empty?
      pdf.text zip_code_and_city.join(' ')
    end
    
  end

  # Add pay to-information
  pdf.bounding_box [322, 130], :width => 220, :height => 45 do

    pdf.stroke_bounds if stroke_bounds

    pdf.text invoice.biller_name
    unless invoice.biller_street_name.blank?
      pdf.text invoice.biller_street_name
    end
    
    zip_code_and_city = []
    zip_code_and_city << invoice.biller_zip_code unless invoice.biller_zip_code.blank?
    zip_code_and_city << invoice.biller_city unless invoice.biller_city.blank?
    unless zip_code_and_city.empty?
      pdf.text zip_code_and_city.join(' ')
    end
    
  end

  # Add amount
  total_amount = format_currency(invoice.total_cost)
  whole_amount = BigDecimal.new(invoice.total_cost.to_s).fix.to_i.to_s
  decimal_amount = BigDecimal.new(invoice.total_cost.to_s).frac.to_i.to_s.rjust(2, '0')
  pdf.bounding_box [225, 20], :width => 60, :height => 10 do

    pdf.stroke_bounds if stroke_bounds
    pdf.text String.new(whole_amount), :align => :right

  end
  pdf.bounding_box [300, 20], :width => 20, :height => 10 do
    pdf.stroke_bounds if stroke_bounds
    pdf.text String.new(decimal_amount)
  end

  # Add account number
  pdf.bounding_box [370, 20], :width => 100, :height => 10 do
    pdf.stroke_bounds if stroke_bounds
    pdf.text invoice.biller_bank_account_number unless invoice.biller_bank_account_number.blank?
  end

end
