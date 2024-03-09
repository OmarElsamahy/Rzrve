class String
  def to_bool
    return false if blank?
    ActiveModel::Type::Boolean.new.cast(downcase)
  end
end

class NilClass
  def to_bool
    false
  end
end

class TrueClass
  def to_bool
    true
  end
end

class FalseClass
  def to_bool
    false
  end
end

class Integer
  def to_bool
    !(self < 1)
  end
end

class Float
  def to_bool
    !(self <= 0)
  end
end

class Symbol
  def to_bool
    !to_s.empty?
  end
end
