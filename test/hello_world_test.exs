defmodule HelloWorldTest do
  use ExUnit.Case, async: false
  doctest HelloWorld
  setup do

    expected_keys = ["AccessKeyId", "SecretAccessKey", "Token", "Expiration"]
    expected_info = Map.new
    |> Map.put(:access_key_id, "AKIAIOSFODNN7EXAMPLE")
    |> Map.put(:secret_access_key, "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")
    |> Map.put(:token, "some_fake_token")

    role_name = "some-security-role-name-AGSETS"
    security_role_list_path = "/latest/meta-data/iam/security-credentials/"
    security_cred_path = security_role_list_path <> role_name

    bypass = Bypass.open
    meta_data_url =  "http://localhost:#{bypass.port}#{security_role_list_path}"

    Bypass.expect bypass, fn conn ->
      assert "GET" == conn.method
      case conn.request_path do
        ^security_role_list_path ->
          Plug.Conn.resp(conn, 200, role_name)
        ^security_cred_path ->
          Plug.Conn.resp(conn, 200, cred_response)
        _ ->
          assert false
      end
    end

    {:ok,
      [
        expected_keys: expected_keys,
        expected_info: expected_info,
        bypass_url: meta_data_url,
        bypass: bypass
      ]
    }
  end

  test "Hitting up bypass", context do
    {:ok, response} = HTTPoison.get(context.bypass_url)
    IO.puts("Test: got #{response.body} from #{context.bypass_url}")
    {:ok, response_the_second} = HTTPoison.get(context.bypass_url <> response.body)
    IO.puts("Test: got #{response_the_second.body} from #{context.bypass_url <> response.body}")
  end

  defp cred_response do
    now = Timex.now
    ~s<
      {
        "Code" : "Success",
        "LastUpdated": "#{now |> Timex.format("{ISO:Basic:Z}") |> elem(1)}",
        "Type": "AWS-HMAC",
        "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
        "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "Token": "some_fake_token",
        "Expiration": "#{now |> Timex.shift(seconds: 1) |> Timex.format("{ISO:Basic:Z}") |> elem(1)}"
      }
    >
  end
end
