steps_for :<%= gem_name %> do
  Given 'there are $n <%= gem_name %>' do |n|
    <%= module_name %>.initial = n.to_i
  end

  When 'I sell $n <%= gem_name %>' do |n|
    <%= module_name %>.sold = n.to_i
  end

  Then 'there should be $n <%= gem_name %> left' do |n|
    <%= module_name %>.left.should == n.to_i
  end
end
