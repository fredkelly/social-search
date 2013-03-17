require 'spec_helper'

describe Comment do
  fixtures :comments
  
  it 'can create comment' do
    comment = Comment.new(search_id: 1, rating: 5, comment: 'Love it!')
    comment.save.should be_true
  end
  
  it 'validates rating range' do
    comment = Comment.new(search_id: 1, rating: 10, comment: 'Love it!')
    comment.valid?.should be_false
  end
  
  it 'validates rating presence' do
    comment = Comment.new(search_id: 1, comment: 'Love it!')
    comment.valid?.should be_false
  end

end