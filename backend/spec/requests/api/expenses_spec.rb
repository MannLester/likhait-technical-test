require 'rails_helper'

RSpec.describe "Api::Expenses", type: :request do
  let!(:food_category) { Category.create!(name: "Food") }
  let!(:transport_category) { Category.create!(name: "Transport") }

  describe "GET /api/expenses" do
  let!(:expense1) { Expense.create!(description: "Lunch", amount: 100.00, category: food_category, date: Date.today) }
  let!(:expense2) { Expense.create!(description: "Taxi", amount: 50.00, category: transport_category, date: Date.today) }

    it "returns all expenses with category information" do
      get "/api/expenses"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end

    it "returns expenses in descending order by date" do
      old_expense = Expense.create!(description: "Old lunch", amount: 30.00, category: food_category, date: Date.today - 5)
      recent_expense = Expense.create!(description: "Recent dinner", amount: 60.00, category: food_category, date: Date.today - 1)

      get "/api/expenses"

      json = JSON.parse(response.body)
      dates = json.map { |e| e["date"] }
      expect(dates).to eq(dates.sort.reverse)
    end

    it "filters expenses by year and month using the date column" do
      jan_expense = Expense.create!(description: "January lunch", amount: 40.00, category: food_category, date: Date.new(2026, 1, 15))
      feb_expense = Expense.create!(description: "February dinner", amount: 80.00, category: food_category, date: Date.new(2026, 2, 10))

      get "/api/expenses", params: { year: 2026, month: 1 }

      json = JSON.parse(response.body)
      descriptions = json.map { |e| e["description"] }
      expect(descriptions).to include("January lunch")
      expect(descriptions).not_to include("February dinner")
    end
  end

  describe "POST /api/expenses" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          expense: {
            description: "Team Lunch",
            amount: 150.50,
            category_id: food_category.id,
            date: Date.today
          }
        }
      end

      it "creates a new expense" do
        expect {
          post "/api/expenses", params: valid_params, as: :json
        }.to change(Expense, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["description"]).to eq("Team Lunch")
      end
    end

    context "with invalid parameters" do
      it "with negative amounts" do
        invalid_params = {
          expense: {
            description: "Invalid expense",
            amount: -100.00,
            category_id: food_category.id,
            date: Date.today
          }
        }

        expect {
          post "/api/expenses", params: invalid_params, as: :json
        }.to change(Expense, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "with empty descriptions" do
        invalid_params = {
          expense: {
            description: "",
            amount: 100.00,
            category_id: food_category.id,
            date: Date.today
          }
        }

        expect {
          post "/api/expenses", params: invalid_params, as: :json
        }.to change(Expense, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end
end
