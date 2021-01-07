class  Exhibit
  attr_reader :name, :cost
  def initialize(args)
    @args = args
    @name = args[:name]
    @cost = args[:cost]
  end 
end
