class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting

  def as_json(options={})
    super(:include => :user)
  end
end
