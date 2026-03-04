require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:category) { Category.create!(name: "Food") }

  let(:valid_attributes) do
    {
      description: "Test expense",
      amount: 50.00,
      category: category,
      date: Date.today
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expense = Expense.new(valid_attributes)
      expect(expense).to be_valid
    end

    it "is invalid with a negative amount" do
      expense = Expense.new(valid_attributes.merge(amount: -10.00))
      expect(expense).not_to be_valid
      expect(expense.errors[:amount]).to include("must be greater than 0")
    end

    it "is invalid with zero amount" do
      expense = Expense.new(valid_attributes.merge(amount: 0))
      expect(expense).not_to be_valid
      expect(expense.errors[:amount]).to include("must be greater than 0")
    end

    it "is invalid without an amount" do
      expense = Expense.new(valid_attributes.merge(amount: nil))
      expect(expense).not_to be_valid
    end

    it "is invalid with an empty description" do
      expense = Expense.new(valid_attributes.merge(description: ""))
      expect(expense).not_to be_valid
      expect(expense.errors[:description]).to include("can't be blank")
    end

    it "is invalid without a description" do
      expense = Expense.new(valid_attributes.merge(description: nil))
      expect(expense).not_to be_valid
    end

    it "is invalid without a date" do
      expense = Expense.new(valid_attributes.merge(date: nil))
      expect(expense).not_to be_valid
    end

    it "is invalid with a future date" do
      expense = Expense.new(valid_attributes.merge(date: Date.today + 30))
      expect(expense).not_to be_valid
      expect(expense.errors[:date]).to include("cannot be in the future")
    end

    it "is valid with today's date" do
      expense = Expense.new(valid_attributes.merge(date: Date.today))
      expect(expense).to be_valid
    end

    it "is valid with a past date" do
      expense = Expense.new(valid_attributes.merge(date: Date.today - 30))
      expect(expense).to be_valid
    end
  end

  describe "associations" do
    it "belongs to a category" do
      expense = Expense.new(valid_attributes)
      expect(expense.category).to eq(category)
    end
  end
end
