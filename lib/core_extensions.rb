class Array
  def count(element)
    select {|item| item == element}.length
  end
end
