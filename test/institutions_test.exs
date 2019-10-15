defmodule Atrium.InstitutionsTest do
  use ExUnit.Case, async: false
  doctest Atrium

  alias Atrium.Institutions

  setup _ do
    {:ok, %{}}
  end

  describe "read_institution" do
    @tag :sandbox
    test "read_institution/1" do
      {:ok, response} = Institutions.read_institution("mxbank")

      assert %{
               "institution" => %{
                 "code" => "mxbank",
                 "medium_logo_url" =>
                   "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/100x100/INS-1572a04c-912b-59bf-5841-332c7dfafaef_100x100.png",
                 "name" => "MX Bank",
                 "small_logo_url" =>
                   "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/50x50/INS-1572a04c-912b-59bf-5841-332c7dfafaef_50x50.png",
                 "supports_account_identification" => false,
                 "supports_account_statement" => false,
                 "supports_account_verification" => true,
                 "supports_transaction_history" => false,
                 "url" => "https://www.mx.com"
               }
             } = response
    end

    @tag :sandbox
    test "read_institution!/1" do
      response = Institutions.read_institution!("mxbank")

      assert %{
               "institution" => %{
                 "code" => "mxbank",
                 "medium_logo_url" =>
                   "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/100x100/INS-1572a04c-912b-59bf-5841-332c7dfafaef_100x100.png",
                 "name" => "MX Bank",
                 "small_logo_url" =>
                   "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/50x50/INS-1572a04c-912b-59bf-5841-332c7dfafaef_50x50.png",
                 "supports_account_identification" => false,
                 "supports_account_statement" => false,
                 "supports_account_verification" => true,
                 "supports_transaction_history" => false,
                 "url" => "https://www.mx.com"
               }
             } = response
    end
  end

  describe "list_institutions" do
    @tag :sandbox
    test "list_institutions/1" do
      {:ok, response} = Institutions.list_institutions(name: "mx")

      assert %{
               "institutions" => [
                 %{
                   "code" => "mxbank",
                   "medium_logo_url" =>
                     "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/100x100/INS-1572a04c-912b-59bf-5841-332c7dfafaef_100x100.png",
                   "name" => "MX Bank",
                   "small_logo_url" =>
                     "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/50x50/INS-1572a04c-912b-59bf-5841-332c7dfafaef_50x50.png",
                   "supports_account_identification" => false,
                   "supports_account_statement" => false,
                   "supports_account_verification" => true,
                   "supports_transaction_history" => false,
                   "url" => "https://www.mx.com"
                 }
               ],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               }
             } = response
    end

    @tag :sandbox
    test "list_institutions!/1" do
      response = Institutions.list_institutions!(name: "mx")

      assert %{
               "institutions" => [
                 %{
                   "code" => "mxbank",
                   "medium_logo_url" =>
                     "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/100x100/INS-1572a04c-912b-59bf-5841-332c7dfafaef_100x100.png",
                   "name" => "MX Bank",
                   "small_logo_url" =>
                     "https://content.moneydesktop.com/storage/MD_Assets/Ipad%20Logos/50x50/INS-1572a04c-912b-59bf-5841-332c7dfafaef_50x50.png",
                   "supports_account_identification" => false,
                   "supports_account_statement" => false,
                   "supports_account_verification" => true,
                   "supports_transaction_history" => false,
                   "url" => "https://www.mx.com"
                 }
               ],
               "pagination" => %{
                 "current_page" => 1,
                 "per_page" => 25,
                 "total_entries" => 1,
                 "total_pages" => 1
               }
             } = response
    end
  end

  describe "read_institution_credentials" do
    @tag :sandbox
    test "read_institution_credentials/1" do
      {:ok, response} = Institutions.read_institution_credentials("mxbank")

      assert %{
               "credentials" => [
                 %{
                   "display_order" => 1,
                   "field_name" => "LOGIN",
                   "guid" => "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1",
                   "label" => "Username",
                   "type" => "LOGIN"
                 },
                 %{
                   "display_order" => 2,
                   "field_name" => "PASSWORD",
                   "guid" => "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d",
                   "label" => "Password",
                   "type" => "PASSWORD"
                 }
               ]
             } = response
    end

    @tag :sandbox
    test "read_institution_credentials!/1" do
      response = Institutions.read_institution_credentials!("mxbank")

      assert %{
               "credentials" => [
                 %{
                   "display_order" => 1,
                   "field_name" => "LOGIN",
                   "guid" => "CRD-9f61fb4c-912c-bd1e-b175-ccc7f0275cc1",
                   "label" => "Username",
                   "type" => "LOGIN"
                 },
                 %{
                   "display_order" => 2,
                   "field_name" => "PASSWORD",
                   "guid" => "CRD-e3d7ea81-aac7-05e9-fbdd-4b493c6e474d",
                   "label" => "Password",
                   "type" => "PASSWORD"
                 }
               ]
             } = response
    end
  end
end
