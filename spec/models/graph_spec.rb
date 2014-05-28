require 'spec_helper'

describe Graph do
  describe "#find_or_create" do
    before(:each) do
      Settings.stub(:auto_tagging).and_return(auto_tagging)
      Object.class_eval { remove_const :Graph }
      load 'app/models/graph.rb'
    end

    context "no auto_tagging" do
      let(:path) { 'a/b/c' }
      let(:auto_tagging) { false }
      subject { Graph.find_or_create(path: path) }
      it { expect(subject.tag_list).to eq [] }
    end

    context "no auto_tagging, with a tag" do
      let(:path) { 'a/b/c' }
      let(:tag) { 'foo' }
      let(:auto_tagging) { false }
      subject { Graph.find_or_create(path: path, tag_list: tag) }
      it { expect(subject.tag_list).to eq ([tag]) }
    end

    context "auto_tagging" do
      let(:path) { 'a/b/c' }
      let(:auto_tagging) { true }
      subject { Graph.find_or_create(path: path) }
      it { expect(subject.tag_list).to eq path.split('/') }
    end

    context "auto_tagging, with a tag" do
      let(:path) { 'a/b/c' }
      let(:tag) { 'foo' }
      let(:auto_tagging) { true }
      subject { Graph.find_or_create(path: path, tag_list: tag) }
      it { expect(subject.tag_list).to eq ([tag] + path.split('/')) }
    end

    after(:all) do
      Settings.stub(:auto_tagging).and_return(true)
      Object.class_eval { remove_const :Graph }
      load 'app/models/graph.rb'
    end
  end

  describe "#find_diff" do
    let(:paths) { [ 'a/b/to_be_added', 'a/b/to_be_kept' ] }
    before {
      described_class.find_or_create(path: 'a/b/to_be_kept')
      described_class.find_or_create(path: 'a/b/to_be_removed')
    }
    before { @plus, @minus = described_class.find_diff(paths) }
    it { expect(@plus).to  eq ['a/b/to_be_added'] }
    it { expect(@minus).to eq ['a/b/to_be_removed'] }
  end
end
