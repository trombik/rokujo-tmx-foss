require "spec_helper"

require "rokujo/tmx/project"

RSpec.describe Rokujo::TMX::Project do
  let(:project) { described_class.new(**args) }
  let(:args) do
    {
      name: "A project",
      template: {
        git_tag: "4c5583adc297cd4a2e2d68b0e3c371e1981ac47d"
      },
      dist_url: "https://example.org/%%git_tag%%.zip",
      no_worksubdir: true,
      po_subdir: "%%name%%-%%git_tag%%"
    }
  end

  describe "#new" do
    it "does not raise" do
      expect do
        project
      end.not_to raise_error
    end
  end

  describe "#name" do
    it "returns name" do
      expect(project.name).to eq "A project"
    end
  end

  describe "#template" do
    it "has the given template" do
      expect(project.template).to include(git_tag: "4c5583adc297cd4a2e2d68b0e3c371e1981ac47d")
    end

    it "includes project name by default" do
      expect(project.template).to include(name: "A project")
    end
  end

  describe "#dist_url" do
    it "returns a string" do
      expect(project.dist_url).to be_a String
    end

    it "replaces templates in the value" do
      expect(project.dist_url).to match(/#{project.template[:git_tag]}\.zip/)
    end
  end

  describe "#po_subdir" do
    it "replaces templates in the value" do
      expect(project.po_subdir).to match(/#{project.name}-#{project.template[:git_tag]}/)
    end
  end

  describe "#no_worksubdir" do
    it "returns TrueClass" do
      expect(project.no_worksubdir).to be_a TrueClass
    end
  end
end
