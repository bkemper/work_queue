require 'test/unit'
require_relative '../lib/work_queue'

class TC_WorkQueue_Exception < Test::Unit::TestCase
  def test_throw
    i = 0
    wq = WorkQueue.new
    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        throw :failure, "Catch me if you can" if index == 3
        i += index
      end
    end
    wq.join
    assert_equal 1, wq.failures.size
    assert_equal "Catch me if you can", wq.failures.first.to_s
    assert_equal 12, i  # 1 + 2 + 4 + 5
  end

  def test_throw_multiple
    i = 0
    wq = WorkQueue.new
    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        throw :failure, "Catch me if you can" if [3,5].index(index)
        i += index
      end
    end
    wq.join
    assert_equal 2, wq.failures.size
    assert_equal "Catch me if you can", wq.failures.first.to_s
    assert_equal 7, i  # 1 + 2 + 4
  end

  def test_failures_not_reset
    i = 0
    wq = WorkQueue.new
    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        throw :failure, "Catch me if you can" if index == 3
        i += index
      end
    end
    wq.join
    assert_equal 1, wq.failures.size
    assert_equal "Catch me if you can", wq.failures.first.to_s
    assert_equal 12, i  # 1 + 2 + 4 + 5

    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        throw :failure, "Catch me if you can" if index == 3
        i += index
      end
    end
    wq.join
    assert_equal 2, wq.failures.size
    assert_equal "Catch me if you can", wq.failures.first.to_s
    assert_equal 24, i
  end

  def test_raise
    i = 0
    wq = WorkQueue.new
    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        raise "Rescue me if you can" if index == 3
        i += index
      end
    end
    wq.join
    assert_equal 1, wq.failures.size
    assert_equal "Rescue me if you can", wq.failures.first.to_s
    assert_equal 12, i  # 1 + 2 + 4 + 5
  end

  def test_exit
    i = 0
    wq = WorkQueue.new
    (1..5).each do |idx|
      wq.enqueue_b(idx) do |index|
        exit(1) if index == 3  # exit raises SystemExit exception
        i += index
      end
    end
    wq.join
    assert_equal 1, wq.failures.size
    assert_equal "exit", wq.failures.first.to_s
    assert_equal 12, i  # 1 + 2 + 4 + 5
  end
end
