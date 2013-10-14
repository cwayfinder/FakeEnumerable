module FakeEnumerable
  def map
    out = []
    each { |e| out << yield(e) }
    out
  end

  def select
    out = []
    each { |e| out << e if yield(e) }
    out
  end

  def sort_by
    map { |a| [yield(a), a] }.sort.map { |a| a[1] }
  end

  def reduce(operation_or_value=nil)
    case operation_or_value
      when Symbol
        return reduce { |s,e| s.send(operation_or_value, e) }
      when nil
        acc = nil
      else
        acc = operation_or_value
    end

    each do |a|
      if acc.nil?
        acc = a
      else
        acc = yield(acc, a)
      end
    end

    return acc
  end
end