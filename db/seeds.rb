user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
tweet1 = Tweet.create(:content => "tweeting!", :user_id => user.id)
tweet2 = Tweet.create(:content => "tweet tweet tweet", :user_id => user.id)
