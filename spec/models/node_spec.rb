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
    context 'default' do
      let(:path) { 'a/b/c' }
      subject { described_class.find_or_create(path: path) }
      it { expect(subject.path).to eq 'a/b/c' }
      it { expect(subject.parent.path).to eq 'a/b' }
      it { expect(subject.parent.parent.path).to eq 'a' }
    end

    context 'mark' do
      let(:path) { 'a/b/c' }
      subject { described_class.find_or_create(path: path, mark: true) }
      it { expect(subject.mark).to be_true }
      it { expect(subject.parent.mark).to be_true }
      it { expect(subject.parent.parent.mark).to be_true }
    end

    context 'default then mark' do
      let(:path1) { 'a/b/c' }
      let(:path2) { 'a/d/e' }
      before { described_class.find_or_create(path: path1) }
      before { described_class.find_or_create(path: path2, mark: true) }
      it { expect(described_class.find_by(path: 'a/b').mark).to be_nil }
      it { expect(described_class.find_by(path: 'a/b/c').mark).to be_nil }
      it { expect(described_class.find_by(path: 'a').mark).to be_true }
      it { expect(described_class.find_by(path: 'a/d').mark).to be_true }
      it { expect(described_class.find_by(path: 'a/d/e').mark).to be_true }
    end
  end

  describe "#unmark_all" do
    let(:path) { 'a/b/c' }
    before { described_class.find_or_create(path: path, mark: true) }
    before { described_class.unmark_all }
    it { Node.all.each {|node| expect(node.mark).to be_nil } }
  end
end
