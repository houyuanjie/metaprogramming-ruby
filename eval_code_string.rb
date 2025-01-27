# 如何动态执行代码？

env = Object.new

env.instance_eval do
  @x = 1
end

bind = env.instance_eval { binding }

eval "puts 'Hello eval!'", bind, __FILE__, __LINE__

eval <<-'RUBY', bind, __FILE__, __LINE__ + 1
  puts 'Hello Ruby!'
  puts "@x = #{@x}"
RUBY

# 使用 Heredoc <<-'RUBY' 语法开始一个多行字符串
#     结束标志是 RUBY, 单引号表示不接受插值
#     开始行号为 __LINE__ + 1
