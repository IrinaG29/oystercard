require "oystercard/version"

module Oystercard
  class Card
    MAX_BALANCE = 100
    MIN_FARE = 1
    attr_reader :balance, :entry_station, :journeys, :journey

    def initialize
      @balance = 0
      @entry_station
      @journeys = []
      @journey = { :entry_station => nil, :exit_station => nil }
    end

    def top_up(money)
      fail "Exceeds max balance" if balance + money >= MAX_BALANCE
      @balance = @balance + money
    end

    def touch_in(entry_station)
      fail "Insufficient funds" if balance < MIN_FARE
      @journey[:entry_station] = entry_station
    end

    def in_journey?
      !!@entry_station
    end

    def touch_out(exit_station)
      deduct(MIN_FARE)
      @entry_station = nil
      @journey[:exit_station] = exit_station
      @journeys << @journey.dup
    end

    private

    def deduct(money)
      @balance = @balance - money
    end
  end
end
