require "spec_helper"

RSpec.describe Rokujo::TMX::FOSS::Extractor::Base do
  let(:logger) { Rokujo::TMX::FOSS::Logger.new }
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
end
