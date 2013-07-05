require 'spec_helper'

describe Section do
  describe "#destroy_all_childless" do
    context "default" do
      before do
        Graph.find_or_create(path: 'a/b/c').destroy
        Section.destroy_all_childless 
      end
      it { expect(Section.find_by(path: 'a/b')).to be_nil }
      it { expect(Section.find_by(path: 'a')).to be_nil }
      it { expect(Section.find_by(path: '')).to be_nil }
    end

    context "section having a child is not destroyed" do
      before do
        Graph.find_or_create(path: 'a/b/c').destroy
        Graph.find_or_create(path: 'a/b/d') # not destroy
        Section.destroy_all_childless 
      end
      it { expect(Section.find_by(path: 'a/b')).not_to be_nil }
      it { expect(Section.find_by(path: 'a')).not_to be_nil }
      it { expect(Section.find_by(path: '')).not_to be_nil }
    end
  end
end

