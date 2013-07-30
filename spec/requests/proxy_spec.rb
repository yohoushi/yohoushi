require 'spec_helper'

# config/application.rb
shared_examples_for "correct_proxy_graph" do
  subject do
    escaped_path = URI::escape(path)
    expected = mfclient.get_graph_uri(path, params)
    stub_request(:get, expected).to_return(status: 200)
    get("graph/#{escaped_path}", params)
  end
  it { should == 200 }
end

shared_examples_for "correct_proxy_complex" do
  subject do
    escaped_path = URI::escape(path)
    expected = mfclient.get_complex_uri(path, params)
    stub_request(:get, expected).to_return(status: 200)
    get("complex/#{escaped_path}", params)
  end
  it { should == 200 }
end

describe "proxy_graph" do
  let(:params) { {} }

  context 'of 4 or more levels' do
    let(:path) { 'a/b/c/d' }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'of 3 levels' do
    let(:path) { 'a/b/c' }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'of 2 levels' do
    let(:path) { 'a/b' }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'has query_params' do
    let(:path) { 'a/b' }
    let(:params) { {foo: 'bar', hoge: 'moge'} }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'includes symbol characters (of 4 levels)' do
    let(:path) { "a/b/> +.c/> +.d" }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'includes symbol characters (of 3 levels)' do
    let(:path) { "a/b/> +.c" }
    it_should_behave_like 'correct_proxy_graph'
  end

  context 'includes symbol characters (of 2 levels)' do
    let(:path) { "a/> +.b" }
    it_should_behave_like 'correct_proxy_graph'
  end
end

describe "proxy_complex" do
  let(:params) { {} }

  context 'normal' do
    let(:path) { 'a/b/c/d' }
    it_should_behave_like 'correct_proxy_complex'
  end
end
