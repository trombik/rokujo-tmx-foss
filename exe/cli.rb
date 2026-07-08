require "yaml"
require "tty-logger"
require "rokujo/tmx/foss/project"

projects = []

YAML.unsafe_load_file("examples/inkscape.yml").each do |project|
  project.transform_keys!(&:to_sym)
  projects << Rokujo::TMX::FOSS::Project.new(**project)
end

projects.each do |p|
  p.fetch
  p.extract
  p.create_tmx
  p.clean
end
