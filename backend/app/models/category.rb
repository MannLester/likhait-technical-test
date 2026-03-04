class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, message: "already exists" },
                   length: { maximum: 100, message: "must be 100 characters or fewer" }
end
