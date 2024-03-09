# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace, controller_last_segment)
    @user = user
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :update, to: :read_create_update
    alias_action :read, :update, to: :read_update
    alias_action :read, :create, to: :read_create
    logger.debug("INSIDE ABILITY")
    logger.debug("CONTROLLER NAMESPACE: #{controller_namespace}")
    logger.debug("USER CLASS: #{user.class.name}")
    user_class = user.class.name
    case controller_namespace
    when "Api::V1"
    when "Api::V1::Auth"
      can :manage, :sessions
      can :manage, :passwords
    end
  end
end
