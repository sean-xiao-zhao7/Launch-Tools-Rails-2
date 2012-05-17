class Category < ActiveRecord::Base
  belongs_to :assessment
  has_many :questions,  :dependent => :destroy
  has_many :mc_options,  :dependent => :destroy

  validates_presence_of :name, :assessment_id

  belongs_to  :parent, :class_name => "Category", :foreign_key => "parent_id"

  has_many    :children,
              :class_name => "Category",
              :foreign_key => "parent_id"

  def has_parent?
    !parent_id.nil?
  end

  def has_child?
    !children.empty?
  end

end
