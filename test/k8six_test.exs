defmodule K8sixTest do
  use ExUnit.Case
  doctest K8six

  test "greets the world" do
    assert K8six.hello() == :world
  end
end
