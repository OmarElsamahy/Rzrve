class String
  def normalize_sql
    gsub(/\s+/, " ")
  end
end
