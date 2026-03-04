require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is valid with a unique name" do
      category = Category.new(name: "Groceries")
      expect(category).to be_valid
    end

    it "is invalid without a name" do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a blank name" do
      category = Category.new(name: "")
      expect(category).not_to be_valid
    end

    it "is invalid with a duplicate name (case-insensitive)" do
      Category.create!(name: "Food")
      duplicate = Category.new(name: "food")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("already exists")
    end

    it "is invalid with a name exceeding 100 characters" do
      category = Category.new(name: "a" * 101)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("must be 100 characters or fewer")
    end
  end

  describe "associations" do
    it "has many expenses" do
      category = Category.create!(name: "Food")
      expense = Expense.create!(
        description: "Lunch",
        amount: 25.00,
        category: category,
        date: Date.today
      )
      expect(category.expenses).to include(expense)
    end

    it "destroys associated expenses when deleted" do
      category = Category.create!(name: "Food")
      Expense.create!(
        description: "Lunch",
        amount: 25.00,
        category: category,
        date: Date.today
      )

      expect { category.destroy }.to change(Expense, :count).by(-1)
    end
  end
end