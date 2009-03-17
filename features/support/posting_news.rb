module PostingNewHelpers
  def remote_service_supported?(target_site)
    %w[rubyforge rubyflow].include? target_site
  end
end

World { |world| world.extend PostingNewHelpers }