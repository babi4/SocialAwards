class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :provider, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  # 
  # 
  

  def self.fetch_by_arr(ids=[])
    users_table = User.arel_table
    User.where users_table[:id].in ids
  end

end
