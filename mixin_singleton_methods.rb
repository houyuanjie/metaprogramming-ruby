# 如何将模块中的方法混入到类中，成为类方法？

module M
  def m_method
    puts 'M#m_method'
  end
end

class A
  include M
end

A.m_method rescue warn $! # => undefined method 'm_method' for class A

# 方法 1 (原理用法): 混入到类的单例类中

class A
  class << self
    include M
  end
end

A.m_method # => M#m_method

# 方法 2 (语法): 使用 extend

class A
  extend M
end

A.m_method # => M#m_method

# 方法 3 (惯用法): 混入时使用 extend

module M
  module ClassMethods
    def m_method
      puts 'M::ClassMethods#m_method'
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end

class A
  include M
end

A.m_method # => M::ClassMethods#m_method
