require "spec_helper"

RSpec.describe Rokujo::TMX::FOSS::Project do
  let(:project) { described_class.new(**args) }
  let(:distdir) { Pathname.new "/usr/ports/distfiles" }
  let(:args) do
    {
      # options
      logger: Rokujo::TMX::FOSS::Logger.new(:app, level: :error),
      distdir: distdir,
      stageidr: "stages",
      # values from file
      name: "project",
      template: {
        git_tag: "4c5583adc297cd4a2e2d68b0e3c371e1981ac47d"
      },
      dist_url: "https://example.org/%%git_tag%%.zip",
      dist_filename: "%%git_tag%%.zip",
      worksubdir: "%%name%%-%%git_tag%%",
      no_worksubdir: true,
      src_language: "en",
      target_language: "ja",
      files: ["src/**/ja.po"]
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
      expect(project.name).to eq "project"
    end
  end

  describe "#template" do
    it "has the given template" do
      expect(project.template).to include(git_tag: "4c5583adc297cd4a2e2d68b0e3c371e1981ac47d")
    end

    it "includes project name by default" do
      expect(project.template).to include(name: "project")
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

  describe "#dist_filename" do
    it "returns Pathname" do
      expect(project.dist_filename).to be_a Pathname
    end

    it "replaces templates in the value" do
      expect(project.dist_filename.to_s).to match(/#{project.template[:git_tag]}\.zip/)
    end
  end

  describe "#no_worksubdir?" do
    it "returns TrueClass" do
      expect(project.no_worksubdir?).to be_a TrueClass
    end

    it "returns true" do
      expect(project.no_worksubdir?).to be true
    end
  end

  describe "#worksubdir" do
    it "returns subdirectory name" do
      expect(project.worksubdir).to eq "#{args[:name]}-#{args[:template][:git_tag]}"
    end
  end

  describe "#logger" do
    it "responds to :info log methods" do
      expect(project.logger).to respond_to :info
    end
  end

  describe "#raw_patterns" do
    it "is Array" do
      expect(project.raw_patterns).to be_a Array
    end
  end

  describe "#stageidr" do
    it "is absolute Pathname" do
      expect(project.stagedir).to be_absolute
    end
  end

  describe "#workdir" do
    it "is absolute Pathname" do
      expect(project.workdir).to be_absolute
    end

    it "ends with worksubdir" do
      expect(project.workdir.to_s).to end_with(args[:worksubdir])
    end
  end

  describe "#distfile" do
    it "is absolute Pathname" do
      expect(project.distfile).to be_a Pathname
    end

    it "ends with dist_filename" do
      expect(project.distfile.to_s).to end_with(args[:dist_filename])
    end
  end

  describe "#distdir" do
    it "is absolute Pathname" do
      expect(project.distdir).to eq Pathname.new("/usr/ports/distfiles")
    end

    it "is not the DISTDIRPREFIX" do
      expect(project.distdir).not_to eq described_class::DISTDIRPREFIX
    end

    context "without distdir" do
      let(:distdir) { nil }

      it "is the same DISTDIRPREFIX" do
        expect(project.distdir).to eq described_class::DISTDIRPREFIX
      end
    end
  end
end
