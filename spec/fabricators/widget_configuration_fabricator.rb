# encoding: utf-8
#

Fabricator(:widget_configuration) do
  user!
  type { WidgetConfiguration::TYPES.sample }
  column { WidgetConfiguration::COLUMNS.sample }
end
