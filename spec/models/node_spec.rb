require 'spec_helper'

describe Node do
  describe "#create_ancestors" do
    let(:path) { 'a/b/c' }
    let(:parent_id) { described_class.create_ancestors(path) }
    let(:parent) { described_class.find(parent_id) }
    it { expect(parent.path).to eq 'a/b' }
    it { expect(parent.parent.path).to eq 'a' }
  end

  describe "#find_or_create" do
    let(:path) { 'a/b/c' }
    subject { described_class.find_or_create(path: path) }
    it { expect(subject.path).to eq 'a/b/c' }
    it { expect(subject.parent.path).to eq 'a/b' }
    it { expect(subject.parent.parent.path).to eq 'a' }
  end

  describe "#destroy_ancestors" do
    pending
  end
end
