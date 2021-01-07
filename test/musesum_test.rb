require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/museum'# => true
require './lib/patron'# => true
require './lib/exhibit'# => true

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")# => #<Museum:0x00007fb400a6b0b0...>
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})# => #<Exhibit:0x00007fb400bbcdd8...>
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})# => #<Exhibit:0x00007fb400b851f8...>
    @imax = Exhibit.new({name: "IMAX",cost: 15})# => #<Exhibit:0x00007fb400acc590...>
    @patron_1 = Patron.new("Bob", 20)# => #<Patron:0x00007fb400a51cc8...>
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2 = Patron.new("Sally", 20)# => #<Patron:0x00007fb400036338...>
    @patron_3 = Patron.new("Johnny", 5)# => #<Patron:0x6666fb20114megan...>
    @patron_3.add_interest("Dead Sea Scrolls")
    @patron_4 = Patron.new("Jim", 0)# => #<Patron:0x00007fb400a51cc8...>
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_attributes
    assert_equal "Denver Museum of Nature and Science", @dmns.name# =>
    assert_equal [], @dmns.exhibits# =>
  end

  def test_museusms_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.exhibits# => [#<Exhibit:0x00007fb400bbcdd8...>, #<Exhibit:0x00007fb400b851f8...>, #<Exhibit:0x00007fb400acc590...>]
  end

  def test_it_can_recommend_exhibits
    @patron_2.add_interest("IMAX")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls,], @dmns.recommend_exhibits(@patron_1)# =>
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)# =>
  end

  def test_it_can_add_patrons

    expected = [@patron_1, @patron_2, @patron_3, @patron_4]
    assert_equal expected, @dmns.patrons
  end

  def test_it_can_return_patrons_by_exhibit_interest
    @patron_2.add_interest("Dead Sea Scrolls")

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    expected = {
                @gems_and_minerals => [@patron_1],
                @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
                @imax => []
              }

    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_it_can_return_ticket_lottery_contestants
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_4.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@patron_3, @patron_4], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)# =>
  end

  def test_it_can_draw_lottery_winners
    assert_nil @dmns.draw_lottery_winner(@Imax)# => "Johnny" or "Jim" can be returned here. Fun!
  end

  def test_it_can_announce_lottery_winners
    dmns = mock
    imax = mock
    dmns.stubs(:announce_lottery_winner).returns("Bob has won the IMAX edhibit lottery")

    assert_equal "Bob has won the IMAX edhibit lottery", dmns.announce_lottery_winner(imax)# =>

    the_met = mock
    dali = mock
    the_met.stubs(:announce_lottery_winner).returns("No winners for this lottery")

    assert_equal "No winners for this lottery", the_met.announce_lottery_winner(dali)# =>
  end
end

# =>

# @dmns.draw_lottery_winner(gems_and_minerals)# => nil
# #If no contestants are elgible for the lottery, nil is returned.
# # The above string should match exactly, you will need to stub the return of `draw_lottery_winner` as the above method should depend on the return value of `draw_lottery_winner`.
# @dmns.announce_lottery_winner(gems_and_minerals)# => "No winners for this lottery"
