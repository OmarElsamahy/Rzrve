module SoftDeletionHelper
  extend ActiveSupport::Concern

  included do
    define_callbacks :soft_destroy, :soft_restore, scope: %i[kind name]
    default_scope { where(deleted_at: nil) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
    scope :with_deleted, -> { unscope(where: :deleted_at) }
  end

  def soft_destroy
    transaction do
      run_callbacks(:soft_destroy) { soft_destroy_record }
    end
    self
  end

  def soft_destroy!
    soft_destroy || raise_error_not_destroyed
  end

  def raise_error_not_destroyed
    raise ActiveRecord::DeleteRestrictionError.new(error: "failed_to_destroy")
  end

  def soft_restore
    transaction do
      run_callbacks(:soft_restore) { soft_restore_record }
    end
    self
  end

  def soft_restore!
    soft_restore || raise_error_not_restored
  end

  def raise_error_not_restored
    raise ActiveRecord::DeleteRestrictionError.new(error: "failed_to_restore")
  end

  def soft_destroy_record
    touch(:deleted_at) if respond_to?(:touch)
  end

  def soft_restore_record
    update_columns(deleted_at: nil) if has_attribute?(:deleted_at)
  end
end
