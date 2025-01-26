# 如何包装原有的方法？

class A
  def do_something
    puts 'do something'
  end
end

module Wrapper
  def before_do_something
    puts 'before do something'
  end

  def after_do_something
    puts 'after do something'
  end
end

# 方法 1 (猴子补丁，不推荐): 方法重命名

class A
  include Wrapper

  # alias_method :do_something, :do_something_original
  alias do_something_original do_something

  def do_something
    before_do_something
    do_something_original
    after_do_something
  end
end

# 方法 2 (前置混入): 使用 prepend

module Wrapper
  def do_something
    before_do_something
    super
    after_do_something
  end
end

class A
  prepend Wrapper
end

# 方法 3 (特殊语法): 使用 refine

module ARefinement
  refine A do
    def before_do_something
      puts 'before do something with refinement'
    end

    def after_do_something
      puts 'after do something with refinement'
    end

    def do_something
      before_do_something
      super
      after_do_something
    end
  end
end

# 需要使用 using 显式启用
using ARefinement

a = A.new
a.do_something
