class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :subusers, :class_name => "User", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_user, :class_name => "User"
  belongs_to :role
  belongs_to :company
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
