# frozen_string_literal: true

module Products
  class UserPolicy < ApplicationPolicy
    authorize :product

    def index?
      verify_permissions!('user.read')
      verify_environment!(
        strict: false,
      )

      case bearer
      in role: Role(:admin | :developer | :sales_agent | :support_agent | :read_only | :environment)
        allow!
      in role: Role(:product) if product == bearer
        allow!
      else
        deny!
      end
    end

    def show?
      verify_permissions!('user.read')
      verify_environment!(
        strict: false,
      )

      case bearer
      in role: Role(:admin | :developer | :sales_agent | :support_agent | :read_only | :environment)
        allow!
      in role: Role(:product) if product == bearer
        allow!
      else
        deny!
      end
    end
  end
end
