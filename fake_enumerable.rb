require 'fiber'

module FakeEnumerable
  def map
    if block_given?
      out = []
      each { |e| out << yield(e) }
      out
    else
      FakeEnumerator.new(self, :map)
    end
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
        return reduce { |s, e| s.send(operation_or_value, e) }
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

    acc
  end
end

class FakeEnumerator
  include FakeEnumerable

  def initialize(target, iter)
    @target = target
    @iter = iter
  end

  def each(&block)
    @target.send(@iter, &block)
  end

  def next
    @fiber ||= Fiber.new do
      each { |e| Fiber.yield(e) }

      raise StopIteration
    end

    if @fiber.alive?
      @fiber.resume
    else
      raise StopIteration
    end
  end

  def with_index
    index = 0
    each do |item|
      out = yield(item, index)
      index += 1
      out
    end

  end

  def rewind
    @fiber = nil
  end
end