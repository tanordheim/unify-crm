# encoding: utf-8
#

# Helper methods for PDF generation.
module PdfHelper

  def prawn_configure_fonts(pdf)

    arial_mappings = {
      :bold => prawn_font_path('Arial Bold.ttf'),
      :bold_italic => prawn_font_path('Arial Bold Italic.ttf'),
      :italic => prawn_font_path('Arial Italic.ttf'),
      :normal => prawn_font_path('Arial.ttf')
    }

    pdf.font_families.update('Arial' => arial_mappings)

  end

  def prawn_left_cell(pdf, text, *args)
    options = args.extract_options!
    options[:align] = :left
    text = String.new(text.to_s) # Prevents "Cannot modify SafeBuffer in-place"
    Prawn::Table::Cell::Text.make(pdf, text, options)
  end

  def prawn_right_cell(pdf, text, *args)
    options = args.extract_options!
    options[:align] = :right
    text = String.new(text.to_s) # Prevents "Cannot modify SafeBuffer in-place"
    Prawn::Table::Cell::Text.make(pdf, text, options)
  end

  private

  def prawn_font_path(filename)
    File.join(Rails.root, 'app', 'assets', 'fonts', filename)
  end

end
