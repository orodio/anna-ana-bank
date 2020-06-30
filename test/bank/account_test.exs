defmodule Bank.AccountTest do
  use ExUnit.Case
  alias Bank.Account, as: Account

  test "Account starts with balance of 0" do
    pid = new_account()
    assert Account.balance(pid) == 0
  end

  test "Can deposit moneys" do
    pid =
      new_account()
      |> Account.deposit(10)
      |> Account.deposit(20)
      |> Account.send_balance(self())

    assert Account.balance(pid) == 30
  end

  test "Cant deposit negative moneys" do
    pid =
      new_account()
      |> Account.deposit(10)
      |> Account.deposit(-20)

    assert Account.balance(pid) == 10
  end

  test "Can withdraw moneys" do
    pid =
      new_account()
      |> Account.deposit(50)
      |> Account.withdraw(10)
      |> Account.withdraw(20)

    assert Account.balance(pid) == 20
  end

  test "Cannot withdraw negative moneys" do
    pid =
      new_account()
      |> Account.deposit(50)
      |> Account.withdraw(10)
      |> Account.withdraw(-20)

    assert Account.balance(pid) == 40
  end

  test "Cannot withdraw more money then you have" do
    pid =
      new_account()
      |> Account.deposit(50)
      |> Account.withdraw(10)
      |> Account.withdraw(50)

    assert Account.balance(pid) == 40
  end

  defp new_account() do
    {:ok, pid} = Account.start_link()
    pid
  end
end
