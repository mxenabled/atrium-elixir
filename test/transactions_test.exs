defmodule Atrium.TransactionsTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.Transactions

  setup _ do
    {:ok, %{}}
  end

  @tag :incomplete
  describe "read_transaction" do
    # incomplete
  end

  @tag :incomplete
  describe "list_transactions" do
    # incomplete
  end

  describe "categorize_and_describe_transactions" do
    @tag :sandbox
    test "categorize_and_describe_transactions/1" do
      transactions = %{
        transactions: [
          %{
            amount: 11.22,
            description: "BEER BAR 65000000764SALT LAKE C",
            identifier: "12",
            type: "DEBIT"
          },
          %{
            amount: 21.33,
            description: "IN-N-OUT BURGER #239AMERICAN FO",
            identifier: "13",
            type: "DEBIT"
          },
          %{
            amount: 1595.33,
            description: "ONLINE PAYMENT - THANK YOU",
            identifier: "14",
            type: "CREDIT"
          }
        ]
      }

      assert {:ok, response} = Transactions.categorize_and_describe_transactions(transactions)

      assert %{
               "transactions" => [
                 %{
                   "amount" => 11.22,
                   "category" => "Alcohol & Bars",
                   "description" => "Beer Bar",
                   "identifier" => "12",
                   "is_bill_pay" => false,
                   "is_direct_deposit" => false,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => false,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => nil,
                   "original_description" => "BEER BAR 65000000764SALT LAKE C",
                   "type" => "DEBIT"
                 },
                 %{
                   "amount" => 21.33,
                   "category" => "Fast Food",
                   "description" => "In N Out Burger",
                   "identifier" => "13",
                   "is_bill_pay" => false,
                   "is_direct_deposit" => false,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => false,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => "MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6",
                   "original_description" => "IN-N-OUT BURGER #239AMERICAN FO",
                   "type" => "DEBIT"
                 },
                 %{
                   "amount" => 1595.33,
                   "category" => "Credit Card Payment",
                   "description" => "Online Payment Thank You",
                   "identifier" => "14",
                   "is_bill_pay" => nil,
                   "is_direct_deposit" => nil,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => nil,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => nil,
                   "original_description" => "ONLINE PAYMENT - THANK YOU",
                   "type" => "CREDIT"
                 }
               ]
             } = response
    end

    @tag :sandbox
    test "categorize_and_describe_transactions!/1" do
      transactions = %{
        transactions: [
          %{
            amount: 11.22,
            description: "BEER BAR 65000000764SALT LAKE C",
            identifier: "12",
            type: "DEBIT"
          },
          %{
            amount: 21.33,
            description: "IN-N-OUT BURGER #239AMERICAN FO",
            identifier: "13",
            type: "DEBIT"
          },
          %{
            amount: 1595.33,
            description: "ONLINE PAYMENT - THANK YOU",
            identifier: "14",
            type: "CREDIT"
          }
        ]
      }

      response = Transactions.categorize_and_describe_transactions!(transactions)

      assert %{
               "transactions" => [
                 %{
                   "amount" => 11.22,
                   "category" => "Alcohol & Bars",
                   "description" => "Beer Bar",
                   "identifier" => "12",
                   "is_bill_pay" => false,
                   "is_direct_deposit" => false,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => false,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => nil,
                   "original_description" => "BEER BAR 65000000764SALT LAKE C",
                   "type" => "DEBIT"
                 },
                 %{
                   "amount" => 21.33,
                   "category" => "Fast Food",
                   "description" => "In N Out Burger",
                   "identifier" => "13",
                   "is_bill_pay" => false,
                   "is_direct_deposit" => false,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => false,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => "MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6",
                   "original_description" => "IN-N-OUT BURGER #239AMERICAN FO",
                   "type" => "DEBIT"
                 },
                 %{
                   "amount" => 1595.33,
                   "category" => "Credit Card Payment",
                   "description" => "Online Payment Thank You",
                   "identifier" => "14",
                   "is_bill_pay" => nil,
                   "is_direct_deposit" => nil,
                   "is_expense" => nil,
                   "is_fee" => nil,
                   "is_income" => nil,
                   "is_international" => nil,
                   "is_overdraft_fee" => nil,
                   "is_payroll_advance" => nil,
                   "merchant_guid" => nil,
                   "original_description" => "ONLINE PAYMENT - THANK YOU",
                   "type" => "CREDIT"
                 }
               ]
             } = response
    end
  end
end
