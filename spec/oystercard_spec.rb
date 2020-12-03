RSpec.describe Oystercard::Card do
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:another_entry_station) { double :another_entry_station }
  let(:another_exit_station) { double :another_exit_station }

  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
  let(:second_journey){ {entry_station: another_entry_station, exit_station: another_exit_station} }

  describe "#top_up" do
    it "tops up the balance" do
      subject.top_up(10)
      expect(subject.balance).to eq(10)
    end

    it "raises an error when reaches max balance" do
      expect { subject.top_up(101) }.to raise_error "Exceeds max balance"
    end
  end

  describe "#touch_in" do
    it "raises error when insufficient funds" do
      expect { subject.touch_in(entry_station) }.to raise_error 'Insufficient funds'
    end

    it "saves the entry station" do
      subject.top_up(10)
      expect(subject.touch_in(entry_station)).to eq(entry_station)
    end

    it "sets entry station for journey" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.journey).to eq({ entry_station: entry_station, exit_station: nil })
    end
  end

  describe "#in_journey?" do
    it "returns not nil when travelling" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.in_journey?).not_to be_nil
    end
  end

  describe "#touch_out" do
    it "reduces the balance by minimum fare" do
      expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::Card::MIN_FARE)
    end

    it "returns nil for entry station" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to be_nil
    end

    it "sets exit station for journey" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journey).to eq({ entry_station: entry_station, exit_station: exit_station })
    end

    it "stores journeys" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys.size).to eq(1)
      expect(subject.journeys).to include journey

      subject.touch_in(another_entry_station)
      subject.touch_out(another_exit_station)
      expect(subject.journeys.size).to eq(2)
      expect(subject.journeys).to eq([journey, second_journey])
    end
  end

  it "that the card has an empty list of journeys by default" do
    expect(subject.journeys).to be_empty
  end
end
