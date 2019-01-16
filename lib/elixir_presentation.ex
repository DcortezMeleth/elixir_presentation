defmodule FirstClassCitizens do
  def func(), do: "Hello world" |> IO.puts
  def high_order_func(f), do: f.()

  def use_example do
    high_order_func(&func/0)
  end
  def use_example2 do
    high_order_func(fn() -> "Hello!" |> IO.puts end)
  end
end

defmodule Recursion do
  def fib(n) when n<2, do: 1
  def fib(n), do: fib(n-1) + fib(n-2)

  def divisors(n), do: n |> divisors(2)
  def divisors(n, d) when d > n, do: []
  def divisors(n, d) when rem(n,d) == 0, do: [d] ++ divisors(div(n,d),d)
  def divisors(n, d), do: divisors(n,d+1)
end


defmodule PatternMatching do
  def match() do
    [head | tail] = [1,2,3,4]                                 # head = 1, tail = [2,3,4]
    [a,b,c] = [1,2,3]                                         # a = 1, b = 2, c = 3
    {:ok, result} = {:ok, 69}                                 # result = 69
    %{:a => one, :c => three} = %{:a => 1, :b => 2, :c =>3}   # one = 1, three = 3
  end
end


defmodule Pipes do
  def sample(x) do
    x
    |> IO.inspect(label: "Phase 1")
    |> String.upcase
    |> IO.inspect(label: "Phase 2")
    |> String.trim
    |> IO.inspect(label: "Phase 3")
    |> String.codepoints()
    |> IO.inspect(label: "Phase 4")
    |> Enum.map(&([&1]))
    |> IO.inspect(label: "Phase 4")
    |> Enum.reverse()
  end
end


defmodule DifferentWays do
  def sqr(l), do: l |> Enum.map(&(&1 * &1))

  def sqr2(l), do: l |> Enum.map(fn(x) -> x*x end)

  def sqr3([]), do: []
  def sqr3([head|tail]), do: [head*head] ++ sqr3(tail)
end

defmodule PureFunctions do
  def parse_path(abs_path) do
    splited_path = abs_path
                    |> URI.parse
                    |> Map.get(:path)
                    |> String.split("/", trim: :true)

    params = abs_path
              |> URI.parse
              |> Map.get(:query)
              |> parse_params()

    {splited_path, params}
  end

  defp parse_params(query) when is_bitstring(query), do: query |> URI.query_decoder |> Enum.into(%{})
  defp parse_params(_), do: %{}
end




defmodule Counter do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts.initial_value, name: opts.name)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_call(:get_data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:increment, state) do
    {:noreply, state+1}
  end
end

#{:ok, pid} = Counter.start_link(5)
#GenServer.call(pid, :get_data)
#GenServer.cast(pid, :increment)



children = [
%{
  id: Counter1,
  start: {Counter, :start_link, [5]}
},
%{
  id: Counter2,
  start: {Counter, :start_link, [0]}
}
]

children = [
%{
  id: 1,
  start: {
    Counter,
    :start_link,
    [%{
      initial_value: 5,
      name: Counter1}]
  }
},
%{
  id: 2,
  start: {
    Counter,
    :start_link,
    [%{
      initial_value: 0,
      name: Counter2}]
  }
},
]

{:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

Supervisor.count_children(pid)

#iex(6)> {:ok, pid2} = Supervisor.start_link(children, strategy: :one_for_one)
#{:ok, #PID<0.124.0>}
#iex(7)> Supervisor.count_children(pid2)
#%{active: 2, specs: 2, supervisors: 0, workers: 2}
#iex(8)> GenServer.cast(Counter1, :increment)
#:ok
#iex(9)> GenServer.call(Counter1, :get_data)
#** (exit) exited in: GenServer.call(Counter1, :get_data, 5000)
#    ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
#    (elixir) lib/gen_server.ex:914: GenServer.call/3
