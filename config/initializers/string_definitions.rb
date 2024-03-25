# frozen_string_literal: true

class String
  def normalize_sql
    gsub(/\s+/, " ")
  end
end
