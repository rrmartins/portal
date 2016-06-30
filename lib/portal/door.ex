defmodule Portal.Door do
  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`
  """
  def transfer(left, right, data) do
    # Frist add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    #Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`
  """
  def push_right(portal) do
    # See if we can pop data from left. If so, push the
    # popped data to the right. Otherwise, do nothing.
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    # Let's return the portal itself
    portal
  end

  @doc """
  Starts a door with the given `color`

  The color is given as a name so we can identify
  the door by color name instead of using  a PID
  """
  def start_link(color) do
    Agent.start_link(fn -> [] end, name: color)
  end

  @doc """
  Get the data currently in the `door`
  """
  def get(door) do
    Agent.get(door, fn list -> list end)
  end

  @doc """
  Pushes `value` into the door.
  """
  def push(door, value) do
    Agent.update(door, fn list -> [value|list] end)
  end

  @doc """
  Pops a `value` from the `door`.

  Returns `{:ok, value}` if there is a value
  of `:error` if the hole is currently empty.
  """
  def pop(door) do
    Agent.get_and_update(door, fn
      []    -> {:error, []}
      [h|t] -> {{:ok, h}, t}
    end)
  end

end
