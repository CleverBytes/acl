defmodule AclWeb.RuleControllerTest do
  use AclWeb.ConnCase

  import Acl.ACLFixtures

  alias Acl.ACL.Rule

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rules", %{conn: conn} do
      conn = get(conn, ~p"/api/rules")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rule" do
    test "renders rule when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/rules", rule: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/rules/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/rules", rule: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rule" do
    setup [:create_rule]

    test "renders rule when data is valid", %{conn: conn, rule: %Rule{id: id} = rule} do
      conn = put(conn, ~p"/api/rules/#{rule}", rule: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/rules/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, rule: rule} do
      conn = put(conn, ~p"/api/rules/#{rule}", rule: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rule" do
    setup [:create_rule]

    test "deletes chosen rule", %{conn: conn, rule: rule} do
      conn = delete(conn, ~p"/api/rules/#{rule}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/rules/#{rule}")
      end
    end
  end

  defp create_rule(_) do
    rule = rule_fixture()
    %{rule: rule}
  end
end
