defmodule ListCmp do

  @doc ~S"""
    Compares whether l2 consists of squared elements from l1.

  ## Examples

    iex> ListCmp.cmpSqr([1,2,3], [1,4,9])
    true

    iex> ListCmp.cmpSqr([1,2,3], [1,2,3])
    false

    iex> ListCmp.cmpSqr([1,2,3], [9,4,1])
    true
  """
  @spec cmpSqr([integer], [integer]) :: boolean
  def cmpSqr(l1, l2) do

  end
end
