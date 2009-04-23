require "foxtrot.jar"

%w(inflector view model headless_view connector binder).each do |file|
  require File.expand_path(File.dirname(__FILE__)) + "/" + file
end
Dir.glob(File.expand_path(File.dirname(__FILE__) + "/handlers/**/*.rb")).each do |file|
  require file
end