$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "rokujo/tmx/project"
require "yaml"

projects = []

YAML.unsafe_load_file("src.yml").each do |project|
  project.transform_keys!(&:to_sym)
  projects << Rokujo::TMX::Project.new(**project)
end

projects.each do |p|
  p.fetch
  p.extract
  p.create_tmx
end
