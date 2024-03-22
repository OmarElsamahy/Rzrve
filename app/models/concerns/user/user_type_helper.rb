# frozen_string_literal: true

module User::UserTypeHelper
  def admin?
    # instance_of?(Admin)
    false
  end

  def user?
    instance_of?(User)
  end
end
