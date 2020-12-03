RSpec.describe Oystercard::Station do
  subject { described_class.new(name: "Hampstead", zone: 1) }

  it "gives the station name" do
    expect(subject.name).to eq("Hampstead")
  end

  it "gives the station zone" do
    expect(subject.zone).to eq(1)
  end
end
