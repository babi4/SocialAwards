class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :provider, :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :nickname, :screen_name, :sex, :bdate
  # attr_accessible :title, :body
  # 
  # 
  

  def self.fetch_by_ids(ids=[])
    users_table = User.arel_table
    User.where users_table[:id].in ids
  end

  def self.find_for_vkontakte_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(uid:         auth.uid,
                         provider:    auth.provider,
                         first_name:  auth.extra.raw_info.first_name,
                         second_name: 'test',
                         nickname:    auth.extra.raw_info.nickname,
                         screen_name: auth.extra.raw_info.screen_name,
                         sex:         auth.extra.raw_info.sex,
                         bdate:       auth.extra.raw_info.bdate,
                        )
    end
    user
  end

end
