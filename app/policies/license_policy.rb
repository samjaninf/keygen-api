# frozen_string_literal: true

class LicensePolicy < ApplicationPolicy
  skip_pre_check :verify_authenticated!, only: %i[validate? validate_key?]

  def index?
    verify_permissions!('license.read')
    verify_environment!(
      allow_nil_environment: true,
    )

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' | 'read_only' }
      allow!
    in role: { name: 'product' } if record.all? { _1.product == bearer }
      allow!
    in role: { name: 'user' } if record.all? { _1.user == bearer }
      allow!
    else
      deny!
    end
  end

  def show?
    verify_permissions!('license.read')
    verify_environment!(
      allow_nil_environment: true,
    )

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' | 'read_only' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      allow!
    in role: { name: 'license' } if record == bearer
      allow!
    else
      deny!
    end
  end

  def create?
    verify_permissions!('license.create')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy&.protected?
    else
      deny!
    end
  end

  def update?
    verify_permissions!('license.update')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    else
      deny!
    end
  end

  def destroy?
    verify_permissions!('license.delete')

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy.protected?
    else
      deny!
    end
  end

  def check_out?
    verify_permissions!('license.check-out')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy.protected?
    in role: { name: 'license' } if record == bearer
      allow!
    else
      deny!
    end
  end

  def check_in?
    verify_permissions!('license.check-in')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy.protected?
    in role: { name: 'license' } if record == bearer
      allow!
    else
      deny!
    end
  end

  def validate?
    verify_permissions!('license.validate')
    verify_environment!(
      allow_nil_environment: true,
    )

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' | 'read_only' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      allow!
    in role: { name: 'license' } if record == bearer
      allow!
    else
      deny!
    end
  end

  def validate_key?
    # FIXME(ezekg) We allow validation without authentication. I'd like
    #              to deprecate this behavior in favor of using license
    #              key authentication.
    allow! if
      bearer.nil? || record.nil?

    allow? :validate, record
  end

  def revoke?
    verify_permissions!('license.revoke')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy.protected?
    else
      deny!
    end
  end

  def renew?
    verify_permissions!('license.renew')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    in role: { name: 'user' } if record.user == bearer
      !record.policy.protected?
    else
      deny!
    end
  end

  def suspend?
    verify_permissions!('license.suspend')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    else
      deny!
    end
  end

  def reinstate?
    verify_permissions!('license.reinstate')
    verify_environment!

    case bearer
    in role: { name: 'admin' | 'developer' | 'sales_agent' | 'support_agent' }
      allow!
    in role: { name: 'product' } if record.product == bearer
      allow!
    else
      deny!
    end
  end

  def me?
    verify_permissions!('license.read')
    verify_environment!

    case bearer
    in role: { name: 'license' } if record == bearer
      allow!
    else
      deny!
    end
  end
end
