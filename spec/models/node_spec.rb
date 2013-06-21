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

    context 'marking then delete non-marked nodes' do
      let(:path) { 'a/b/c' }
      before {
        @marks = described_class.start_marking
        described_class.find_or_create(path: path)
        described_class.where.not(:id => @marks.uniq).destroy_all
      }
      it { expect(@marks).to include(described_class.find_by(path: '').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a/b').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a/b/c').id) }
      it { expect(described_class.all.map(&:path)).to eq ['', 'a', 'a/b', 'a/b/c'] }
    end

    context 'default then marking then delete non-marked nodes' do
      let(:path1) { 'a/b/c' }
      let(:path2) { 'a/d/e' }
      before {
        described_class.find_or_create(path: path1) # means a graph which does not exist in gf anymore
        @marks = described_class.start_marking
        described_class.find_or_create(path: path2) # means a graph which exists in gf
        described_class.where.not(:id => @marks.uniq).destroy_all
      }
      it { expect(@marks).to include(described_class.find_by(path: '').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a/d').id) }
      it { expect(@marks).to include(described_class.find_by(path: 'a/d/e').id) }
      it { expect(described_class.all.map(&:path)).to eq ['', 'a', 'a/d', 'a/d/e'] }
    end
  end
end
