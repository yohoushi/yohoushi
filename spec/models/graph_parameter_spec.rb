require 'spec_helper'

describe GraphParameter do
  let(:past) { 3.days.ago.strftime('%F %T') }
  let(:later) { 10.minutes.ago.strftime('%F %T') }
  let(:from)  { past }
  let(:to)    { later }
  let(:size)  { 'M' }
  let(:term)  { 'd' }

  SHORTABLE_TERMS = %w(c h 4h n 8h d 3d)
  NORMAL_TERMS = %w(w m y)

  before do
    @graph_parameter = described_class.new(:from => from, :to => to, :t => term, :size => size)
  end

  describe "#from_at" do
    subject { @graph_parameter.from_at }
    context "default" do 
      it { expect(subject).to eq from }
    end
    context ":from is not time formatted string" do 
      let(:from) { 'aaa' }
      it { expect(subject).to be_nil }
    end
  end

  describe "#to_at" do
    subject { @graph_parameter.to_at }
    context "default" do 
      it { expect(subject).to eq to }
    end
    context ":to is not time formatted string" do 
      let(:to) { 'aaa' }
      it { expect(subject).to be_nil }
    end
  end

  describe "#graph_uri_params" do
    subject { @graph_parameter.graph_uri_params }
    context "default" do
      it { expect(subject.keys).to include('t', 'from', 'to', 'width', 'height') }
    end
    context "thumbnail" do
      let(:size) { 'thumbnail' }
      it { expect(subject.keys).to include('t', 'from', 'to', 'width', 'height', 'notitle') }
      it { expect(subject['notitle']).to eq '1' }
    end
    context "short_metrics is not configured" do
      %w(c h 4h n 8h d 3d).each do |t|
        context "params['t'] => #{t}" do
          let(:term) { t }
          it { expect(subject['t']).to eq "s#{t}" }
        end
      end
      %w(w m y).each do |t|
        context "params['t'] => #{t}" do
          let(:term) { t }
          it { expect(subject['t']).to eq "#{t}" }
        end
      end
    end
    context "short_metrics is true" do
      before do
        Settings.multiforecast.stub(:short_metrics).and_return(true)
      end
      SHORTABLE_TERMS.each do |t|
        context "params['t'] => #{t}" do
          let(:term) { t }
          it { expect(subject['t']).to eq "s#{t}" }
        end
      end
      NORMAL_TERMS.each do |t|
        context "params['t'] => #{t}" do
          let(:term) { t }
          it { expect(subject['t']).to eq "#{t}" }
        end
      end
    end
    context "short_metrics is false" do
      before do
        Settings.multiforecast.stub(:short_metrics).and_return(false)
      end
      (SHORTABLE_TERMS + NORMAL_TERMS).each do |t|
        context "params['t'] => #{t}" do
          let(:term) { t }
          it { expect(subject['t']).to eq "#{t}" }
        end
      end
    end
  end

  describe "#validate" do
    subject { @graph_parameter.validate }
    context "default" do 
      it { expect(subject.errors[:from]).to be_empty }
    end
    context ":from equals :to" do 
      let(:from) { later }
      let(:to)   { later }
      it { expect(subject.errors[:from].first).to eq 'must be older than `to`.' }
    end
    context ":from is future than :to" do 
      let(:from) { later }
      let(:to)   { past }
      it { expect(subject.errors[:from].first).to eq 'must be older than `to`.' }
    end
  end

end
