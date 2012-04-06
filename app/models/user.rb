class User < ActiveRecord::Base
  # TODO app config
  STATUSES = ["Out", "In", "Vacation"]

  attr_accessible :email, :password, :password_confirmation, :status
  has_secure_password
  before_create :init_status
  validates_presence_of :password, :on => :create

  private
  def init_status
    self.status = STATUSES.first
  end
end
