module ActiveRecord
  class DeleteRestrictionError < ActiveRecordError
    attr_accessor :reflection_name, :humanized_reflection_name

    def initialize(name = nil)
      @reflection_name = name
      @humanized_reflection_name = name.to_s.tr("_", " ")
      if name
        super("Cannot delete record because of dependent #{name}")
      else
        super
      end
    end
  end
end
