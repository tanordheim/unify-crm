When /^I fill in "([^"]*)" with "([^"]*)"$/ do |field_ref, value|
  fill_in field_ref, :with => value
end

When /^I select "([^"]*)" from "([^"]*)"$/ do |value, field_ref|
  select(value, :from => field_ref)
end

When /^I submit the form$/ do

  # The selector path to the button differs depending on if we are on the login
  # screen, in a dialog or on a normal page.
  if page.all(:css, '.login-screen').size > 0
    page.find(:css, '.login-screen form button[type="submit"]').click
  elsif page.all(:css, '.modal form').size > 0
    page.find(:css, '.modal form button[type="submit"]').click
  else
    page.find(:css, '.content form button[type="submit"]').click
  end

end

When /^I set the "([^"]*)" slider to (\d+)$/ do |label, value|
  field_name = page.find(:css, 'label', text: label)[:for]
  page.execute_script "s=$('##{field_name}_slider');"
  page.execute_script "s.slider('option', 'value', #{value});"
  page.execute_script "s.slider('option','slide').call(s,null,{ handle: $('.ui-slider-handle', s), value: #{value} });"
end

Given /^I set "([^"]*)" to "([^"]*)" via inline editing$/ do |name, value|

  page.execute_script <<-JS
    
    var field = $('.best_in_place[data-attribute=#{name}]');
    field.click();

    var inputs = $('input', field);
    var textAreas = $('textarea', field);

    if (inputs.length > 0) {
      inputs.val('#{value}');
      var form = $('form', field);
      form.submit();
    } else if (textAreas.length > 0) {
      textAreas.val('#{value}');
      textAreas.blur();
    }

  JS
  
  sleep 0.2
  
end

When /^I select "([^"]*)" from "([^"]*)" via inline editing$/ do |value, name|

  page.execute_script <<-JS

    var field = $('.best_in_place[data-attribute="#{name}"]');
    field.click();

    var dropdown = $('select', field);
    var option = $('option:contains("#{value}")', dropdown);
    var optionId = option.val();
    dropdown.val(optionId);

    dropdown.change();
    
  JS

  sleep 1

end

When /^I type "([^"]*)" in "([^"]*)" and select "([^"]*)" from autocomplete results$/ do |value, field_ref, autocomplete_value|

  field = page.find(:css, "##{field_ref}")
  field.set(value)

  page.execute_script "$('##{field_ref}').trigger('keydown');"
  sleep 1
  
  page.execute_script <<-JS
    var element = $('.ui-menu-item a:contains("#{autocomplete_value}")');
    element.trigger('mouseenter').click();
  JS

  sleep 0.2

end
