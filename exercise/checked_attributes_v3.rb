# 类宏

class Class
  def attr_checked(attr, &vld)
    define_method attr do
      instance_variable_get("@#{attr}")
    end
    define_method "#{attr}=" do |value|
      raise RuntimeError, 'Invalid attribute' unless vld.call(value)
      instance_variable_set("@#{attr}", value)
    end    
  end
end

# Tests

require 'test/unit'

class Person
  attr_checked :age do |age|
    age >= 18
  end
end

class TestCheckedAttributes < Test::Unit::TestCase
  def setup
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_invalid_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end
end
