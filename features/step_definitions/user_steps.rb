Given /^I have filled all the parameters correctly$/ do
  @view.rootPath.text = "/Users/dema/dev/LineCounter"
  @view.extensions.text = "java js sql xml properties html py css conf page jwc bat form script cmd rb xslt template xsl htm iss pas xsd"
  @view.exceptions.text = "log build bin javadoc"
  @view.commentsRegex.text = /^[\/\*\*|\/\/|\*|\*\/|\-\-|\#]/.to_s
  @view.outputFile.text = "/Users/dema/dev/LineCounter/files.csv"
end

When /^I click the GO button$/ do
  @presenter.go_button_mouse_released
  sleep 1
end

Then /^I should have shown a line count$/ do
  @view.status.text.should match /\d* lines/
end

Then /^I should have a file report generated in CSV format$/ do
  File.exists?("/Users/dema/dev/LineCounter/files.csv").should be_true
end

Then /^I should not have any error messages displaying$/ do
  @view.validation.text.should be_empty
  @view.validation.visible.should_not be_true
end

Given /^I have not filled all the parameters correctly$/ do
  @view.rootPath.text = ""
  @view.extensions.text = ""
  @view.exceptions.text = ""
  @view.commentsRegex.text = ""
  @view.outputFile.text = ""
end

Then /^I should have shown a error message$/ do
  @view.validation.text.should_not be_empty
  @view.validation.visible.should be_true
end

Then /^I should have nothing shown in the status area$/ do
  @view.status.text.should be_empty
  @view.status.visible.should_not be_true
end

Given /^I am at the Main Screen$/ do
  @view.should_not be_nil
end

When /^I click the Choose\.\.\. button for (.+)$/ do |input|
  @button = input.split(' ').join('_')
  @presenter.send("#{@button}_button_mouse_released")
end

Then /^I should be shown a File Picker dialog$/ do
  param = @button.camelize(false).to_sym
  @view[param].should == "some_file.dat"
end