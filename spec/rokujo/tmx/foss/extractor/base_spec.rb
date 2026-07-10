require "spec_helper"

RSpec.describe Rokujo::TMX::FOSS::Extractor::Base do
  let(:logger) { Rokujo::TMX::FOSS::Logger.new(:app) }
  let(:file) do
    file = instance_double(Pathname)
    allow(file).to receive_messages(
      to_s: "foo.zip",
      extname: ".zip",
      exist?: true
    )
    file
  end
  let(:args) do
    dest_dir = instance_double(Pathname)
    allow(dest_dir).to receive_messages(
      exist?: true,
      directory?: true,
      writable?: true
    )
    {
      file: file,
      dest_dir: dest_dir,
      logger: logger
    }
  end
  let(:instance) do
    instance = described_class.new(**args)
    allow(instance).to receive_messages(
      supported_extentions: [".zip"]
    )
    instance
  end

  describe "#new" do
    it "does not raise" do
      expect { instance }.not_to raise_error
    end
  end

  describe "#check_sanity" do
    it "does not raise" do
      expect { instance.check_sanity }.not_to raise_error
    end
  end

  describe "#extract" do
    it "raises NotImplementedError" do
      expect { instance.extract }.to raise_error NotImplementedError
    end
  end

  describe "extname" do
    it "returns .zip" do
      expect(instance.extname).to eq ".zip"
    end

    context "when extname is 1.2.3.zip" do
      let(:file) do
        file = instance_double(Pathname)
        allow(file).to receive_messages(
          to_s: "1.2.3.zip",
          extname: ".zip",
          exist?: true
        )
        file
      end

      it "returns .zip" do
        expect(instance.extname).to eq ".zip"
      end
    end

    context "when extname is 1.2.3.tar.gz" do
      let(:file) do
        file = instance_double(Pathname)
        allow(file).to receive_messages(
          to_s: "1.2.3.tar.gz",
          extname: ".gz",
          exist?: true
        )
        file
      end

      it "returns .tar.gz" do
        expect(instance.extname).to eq ".tar.gz"
      end
    end

    context "when extname is 1.2.3.tar.xz" do
      let(:file) do
        file = instance_double(Pathname)
        allow(file).to receive_messages(
          to_s: "1.2.3.tar.xz",
          extname: ".xz",
          exist?: true
        )
        file
      end

      it "returns .tar.xz" do
        expect(instance.extname).to eq ".tar.xz"
      end
    end
  end
end
