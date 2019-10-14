defmodule Atrium.MerchantsTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.Merchants

  describe "read_merchants" do
    test "read_merchant/1" do
      assert {:ok, response} = Merchants.read_merchant("MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6")

      assert %{
               "merchant" => %{
                 "created_at" => "2017-04-20T19:30:20Z",
                 "guid" => "MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6",
                 "logo_url" =>
                   "https://s3.amazonaws.com/MD_Assets/merchant_logos/in-n-out-burger.png",
                 "name" => "In N Out Burger",
                 "updated_at" => "2019-01-04T23:53:34Z",
                 "website_url" => "https://www.in-n-out.com"
               }
             } = response
    end

    test "read_merchant!/1" do
      response = Merchants.read_merchant!("MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6")

      assert %{
               "merchant" => %{
                 "created_at" => "2017-04-20T19:30:20Z",
                 "guid" => "MCH-4a889eb0-0459-f66f-a137-c5e06409d8e6",
                 "logo_url" =>
                   "https://s3.amazonaws.com/MD_Assets/merchant_logos/in-n-out-burger.png",
                 "name" => "In N Out Burger",
                 "updated_at" => "2019-01-04T23:53:34Z",
                 "website_url" => "https://www.in-n-out.com"
               }
             } = response
    end
  end
end
