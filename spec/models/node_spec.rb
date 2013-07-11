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
    let(:path) { 'a/b/c' }
    context "default" do
      before { described_class.find_or_create(path: path).destroy_ancestors }
      it { expect(described_class.find_by(path: 'a/b/c')).to be_nil }
      it { expect(described_class.find_by(path: 'a/b')).to be_nil }
      it { expect(described_class.find_by(path: 'a')).to be_nil }
      it { expect(described_class.find_by(path: '')).to be_nil }
    end

    context "section having a child is not destroyed" do
      before { described_class.find_or_create(path: 'a/b/d') }
      before { described_class.find_or_create(path: 'a/b/c').destroy_ancestors }
      it { expect(described_class.find_by(path: 'a/b/c')).to be_nil }
      it { expect(described_class.find_by(path: 'a/b/d')).not_to be_nil }
      it { expect(described_class.find_by(path: 'a/b')).not_to be_nil }
      it { expect(described_class.find_by(path: 'a')).not_to be_nil }
      it { expect(described_class.find_by(path: '')).not_to be_nil }
    end
  end

  describe "#basename" do
    context "root" do
      context "default" do
        subject { described_class.find_or_create(path: '') }
        it { expect(subject.basename).to eq 'Home' }
      end

      context "dirname" do
        subject { described_class.find_or_create(path: '') }
        it { expect(subject.basename('foo')).to eq 'Home' }
      end
    end

    context "node" do
      let(:path) { 'a/a/a' }
      context "default" do
        subject { described_class.find_or_create(path: path) }
        it { expect(subject.basename).to eq 'a' }
      end

      context "matching dirname" do
        subject { described_class.find_or_create(path: path) }
        it { expect(subject.basename('a')).to eq 'a/a' }
      end

      context "nomatching dirname" do
        subject { described_class.find_or_create(path: path) }
        it { expect(subject.basename('b')).to eq 'a/a/a' }
      end
    end
  end
end
