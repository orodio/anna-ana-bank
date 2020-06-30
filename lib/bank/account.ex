defmodule Bank.Account do
  use GenServer
  alias Bank.Account

  defstruct balance: 0, history: []

  def start_link() do
    GenServer.start_link(__MODULE__, 0)
  end

  def init(balance) do
    {:ok, %Account{balance: balance}}
  end

  def balance(account_pid) do
    GenServer.call(account_pid, :balance)
  end

  def send_balance(account_pid, to_pid) do
    GenServer.cast(account_pid, {:send_balance, to_pid})
    account_pid
  end

  def deposit(account_pid, amount) do
    GenServer.cast(account_pid, {:deposit, amount})
    account_pid
  end

  def withdraw(account_pid, amount) do
    GenServer.cast(account_pid, {:withdraw, amount})
    account_pid
  end

  def handle_cast({:send_balance, pid}, acct = %Account{}) do
    send(pid, {:balance, Map.get(acct, :balance)})
    {:noreply, acct}
  end

  def handle_cast(event = {:deposit, amount}, acct = %Account{}) when amount >= 0 do
    acct =
      acct
      |> Map.update!(:balance, &(&1 + amount))
      |> Map.update!(:history, &[event | &1])

    {:noreply, acct}
  end

  def handle_cast(event = {:withdraw, amount}, acct = %Account{balance: balance})
      when amount >= 0 and amount <= balance do
    acct =
      acct
      |> Map.update!(:balance, &(&1 - amount))
      |> Map.update!(:history, &[event | &1])

    {:noreply, acct}
  end

  def handle_cast(_, balance) do
    {:noreply, balance}
  end

  def handle_call(:balance, _from, acct = %Account{balance: balance}) do
    {:reply, balance, acct}
  end
end
