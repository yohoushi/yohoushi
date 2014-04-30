require 'spec_helper'

describe GraphParameter do
  let(:past) { 3.days.ago.strftime('%F %T') }
  let(:later) { 10.minutes.ago.strftime('%F %T') }
  let(:from)  { past }
  let(:to)    { later }
  let(:size)  { 'M' }
  let(:term)  { 'd' }
  let(:lower_limit) { '-100' }
  let(:upper_limit) { '100000000' }

  SHORTABLE_TERMS = %w(c h 4h n 8h d 3d)
  NORMAL_TERMS = %w(w m y)

  before do
    @graph_parameter = described_class.new(:from => from, :to => to, :t => term, :size => size, :lower_limit => lower_limit, :upper_limit => upper_limit)
  end

  describe "#initialize" do
    subject { @graph_parameter }

    context "default" do
      subject { @graph_parameter = described_class.new }
      its(:term) { should == 'd' }
      its(:from) { should be_nil }
      its(:to)   { should be_nil }
      its(:size) { should == 'thumbnail' }
      its(:lower_limit) { should be_nil }
      its(:upper_limit) { should be_nil }
    end

    context "valid" do
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

    [:lower_limit, :upper_limit].each do |sym|
      ["10", "0", "-10"].each do |val|
        context "valid value `#{val}` is set to #{sym}" do
          let(sym) { val }
          it { expect(subject.errors[sym]).to be_empty }
        end
      end
      ["10", "0", "-10"].each do |val|
        %w(K M G T).each do |unit|
          context "valid value `#{val}#{unit}` is set to #{sym}" do
            let(sym) { "10K" }
            it { expect(subject.errors[sym]).to be_empty }
          end
        end
      end
      context "invalid #{sym} input" do
        let(sym) { "invalid_input" }
        it { expect(subject.errors[sym].first).to eq 'is invalid.' }
      end
    end
  end

  describe "#update" do
    before { @graph_parameter_to_update = described_class.new(:from => from, :to => to, :t => term, :size => size, :lower_limit => lower_limit, :upper_limit => upper_limit) }

    context "from valid paramters" do
      context "empty update should keep variables" do
        subject { @graph_parameter_to_update.update({}) }
        its(:term) { should == @graph_parameter.term }
        its(:from) { should == @graph_parameter.from }
        its(:to)   { should == @graph_parameter.to }
        its(:size) { should == @graph_parameter.size }
        its(:lower_limit) { should == @graph_parameter.lower_limit }
        its(:upper_limit) { should == @graph_parameter.upper_limit }
      end

      context "valid update" do
        subject { @graph_parameter_to_update.update(:from => past, :to => later) }
        its(:errors) { should be_empty }
      end

      context "invalid update should add errors" do
        subject { @graph_parameter_to_update.update(:from => later, :to => past) }
        it { expect(subject.errors[:from].first).to eq 'must be older than `to`.' }
      end
    end

    context "from invalid parameters" do
      let(:from) { later }
      let(:to)   { past }

      context "empty update should keep variables and errors" do
        subject { @graph_parameter_to_update.update({}) }
        its(:term) { should == @graph_parameter.term }
        its(:from) { should == @graph_parameter.from }
        its(:to)   { should == @graph_parameter.to }
        its(:size) { should == @graph_parameter.size }
        it { expect(subject.errors.full_messages).to eq @graph_parameter.errors.full_messages }
      end

      context "valid update should remove errors" do
        subject { @graph_parameter_to_update.update(:from => past, :to => later) }
        its(:errors) { should be_empty }
      end

      context "invalid updated should remove previous errors and add new errors" do
        subject { @graph_parameter_to_update.update(:from => later, :to => past) }
        it { expect(subject.errors[:from].first).to eq 'must be older than `to`.' }
      end
    end
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
      it { expect(subject.keys).to include('t', 'from', 'to', 'width', 'height', 'lower_limit', 'upper_limit') }
    end
    context "thumbnail" do
      let(:size) { 'thumbnail' }
      it { expect(subject.keys).to include('t', 'from', 'to', 'width', 'height', 'notitle', 'lower_limit', 'upper_limit') }
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
    context "no suffix is put in lower/upper limit" do
      [:lower_limit, :upper_limit].each do |sym|
        %w(-10 0 10).each do |limit|
          context "params['#{sym}'] => #{limit}" do
            let(sym) { limit }
            it { expect(subject[sym.to_s]).to eq limit.to_i }
          end
        end
      end
    end
    context "suffix is put in lower/upper limit" do
      map = {
        'K' => 1_000,
        'M' => 1_000_000,
        'G' => 1_000_000_000,
        'T' => 1_000_000_000_000,
      }
      [:lower_limit, :upper_limit].each do |sym|
        %w(-10 0 10).each do |limit|
          map.keys.each do |unit|
            expected = limit.to_i * map[unit]
            context "params['#{sym}'] => #{expected}" do
              let(sym) { limit + unit }
              it { expect(subject[sym.to_s]).to eq expected }
            end
          end
        end
      end
    end
    context "invalid string is passed to lower/upper limit" do
      [:lower_limit, :upper_limit].each do |sym|
        context "params['#{sym}'] => nil" do
          let(sym) { "invalid_input" }
          it { expect(subject[sym.to_s]).to be_nil }
        end
      end
    end
  end

end
