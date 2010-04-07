require 'yaml'  
$config ||= (YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/application.yml')))