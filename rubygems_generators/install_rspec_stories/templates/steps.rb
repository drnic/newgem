# TODO: Make the steps talk to your code
steps_for :rubyfools do
  Given 'there are $n rubyfools' do |n|
    @initial = n.to_i
  end

  When 'I sell $n rubyfools' do |n|
    @sold = n.to_i
  end

  Then 'there should be $n rubyfools' do |n|
    @left = n.to_i + 1
    (@initial - @sold).should == @left
  end
end