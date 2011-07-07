# Specifies all the content types returned by the API versions.
API_CONTENT_TYPES = {
  :'1' => 'application/vnd.unify.api.v1+json; charset=utf-8'
}

# Set the "last API version" so we can properly match content types later.
def set_last_api_version(version)
  @last_api_version = version
end

# Returns the last used APi version.
def last_api_version
  @last_api_version
end

Given /^I have an API application key$/ do
  step %{I have 1 API application}
  header('X-Unify-Token', Instance.first.api_applications.first.token)
end

Given /^I accept API version (\d+)$/ do |version|
  header('Accept', "application/vnd.unify.api.v#{version}+json")
  set_last_api_version(version.to_sym)
end

When /^I send an API request to "([^"]*)"$/ do |path|
  get(['/api', path].join)
end

Then /^the response code should be (\d+)$/ do |response_code|
  last_response.status.should == response_code.to_i
end

Then /^the JSON response should be an? "([^"]*)" array with (\d+) elements?$/ do |root_element, element_count|

  last_response.content_type.should == API_CONTENT_TYPES[last_api_version]

  document = JSON.parse(last_response.body, :symbolize_names => true)
  document.keys.size.should == 1
  document.key?(root_element.to_sym).should == true
  document[root_element.to_sym].length.should == element_count.to_i

end

Then /^the JSON response should be an? "([^"]*)" object$/ do |object_name|

  last_response.content_type.should == API_CONTENT_TYPES[last_api_version]

  document = JSON.parse(last_response.body, :symbolize_names => true)
  document.keys.size.should == 1
  document.key?(object_name.to_sym).should == true
  
end

Then /^the JSON response body should be empty$/ do
  last_response.content_type.should == API_CONTENT_TYPES[last_api_version]
  last_response.body.should be_blank
end
