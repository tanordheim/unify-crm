# encoding: utf-8
#

# Helpers for the Contact model class.
module ContactHelper

  # Builds a list of summaries for the specified list of employments.
  #
  # @param [ Array ] employments An array of +Employment+ instances.
  #
  # @return [ Array ] An array of DOM elements describing each employment.
  def employment_summaries(employments)
    employments.map do |employment|
      summary = ''
      summary << "#{employment.title} at " unless employment.title.blank?
      summary << link_to(employment.organization.name, employment.organization)
      summary.html_safe
    end
  end

end
