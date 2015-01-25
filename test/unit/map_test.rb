require 'test_helper'

class MapTest < ActiveSupport::TestCase
  test "fail on missing comment" do
    m = Map.create( :latitude => 9.9, 
					:longitude => 9.9, 
					:category => "People", 
					:comment => nil )
	assert m.errors.on( :comment ), "Failed on missing Comment"
  end
  test "fail on missing latitude" do
    m = Map.create( :latitude => nil,
					:longitude => 9.9, 
					:category => "People", 
					:comment => "this place is awesome!" )
	assert m.errors.on(:latitude), "Failed on missing latitude"
  end
  test "fail on missing longitude" do
    m = Map.create( :latitude => 9.9, 
					:longitude => nil, 
					:category => "People", 
					:comment => "why is my longitude missing?" )
	assert m.errors.on(:longitude), "Failed on missing longitude"
  end
end
