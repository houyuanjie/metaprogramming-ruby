# 方法 1: eval + 打开类

# def add_checked_attribute(cls, attr)
#   eval <<-RUBY
#     class #{cls}
#       def #{attr}
#         @#{attr}
#       end
#
#       def #{attr}=(value)
#         raise RuntimeError, 'Invalid attribute' unless value
#         @#{attr} = value
#       end
#     end
#   RUBY
# end

# 方法 2: class_eval

# def add_checked_attribute(cls, attr)
#   cls.class_eval <<-RUBY
#     def #{attr}
#       @#{attr}
#     end
#
#     def #{attr}=(value)
#       raise RuntimeError, 'Invalid attribute' unless value
#       @#{attr} = value
#     end
#   RUBY
# end

# 方法 3: define_method

def add_checked_attribute(cls, attr)
  cls.define_method attr do
    instance_variable_get("@#{attr}")
  end
  cls.define_method "#{attr}=" do |value|
    raise RuntimeError, 'Invalid attribute' unless value
    instance_variable_set("@#{attr}", value)
  end
end

# Tests

require 'test/unit'

class Person
end

class TestCheckedAttributes < Test::Unit::TestCase
  def setup
    add_checked_attribute Person, :age
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_nil_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = nil
    end
  end

  def test_refuses_false_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = false
    end
  end
end
