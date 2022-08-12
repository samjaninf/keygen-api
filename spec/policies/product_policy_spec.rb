# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

describe ProductPolicy, type: :policy do
  subject { described_class.new(record, account:, bearer:, token:) }

  with_role_authorization :admin do
    with_scenarios %i[accessing_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          without_token_permissions { denies :index }

          allows :index
        end

        with_wildcard_permissions { allows :index }
        with_default_permissions  { allows :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_a_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          without_token_permissions { denies :show }

          allows :show
        end

        with_permissions %w[product.create] do
          without_token_permissions { denies :create }

          allows :create
        end

        with_permissions %w[product.update] do
          without_token_permissions { denies :update }

          allows :update
        end

        with_permissions %w[product.delete] do
          without_token_permissions { denies :destroy }

          allows :destroy
        end

        with_wildcard_permissions do
          without_token_permissions do
            denies :show, :create, :update, :destroy
          end

          allows :show, :create, :update, :destroy
        end

        with_default_permissions do
          without_token_permissions do
            denies :show, :create, :update, :destroy
          end

          allows :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end

    with_scenarios %i[accessing_another_account accessing_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_another_account accessing_a_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_permissions %w[product.create] do
          denies :create
        end

        with_permissions %w[product.update] do
          denies :update
        end

        with_permissions %w[product.delete] do
          denies :destroy
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end
  end

  with_role_authorization :product do
    with_scenarios %i[accessing_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_itself] do
      with_token_authentication do
        with_permissions %w[product.read] do
          allows :show
        end

        with_permissions %w[product.update] do
          allows :update
        end

        with_wildcard_permissions do
          denies :create, :destroy
          allows :show, :update
        end

        with_default_permissions do
          denies :create, :destroy
          allows :show, :update
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end

    with_scenarios %i[accessing_a_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_permissions %w[product.update] do
          denies :update
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end
  end

  with_role_authorization :license do
    with_scenarios %i[accessing_its_products] do
      with_license_authentication do
        with_permissions %w[product.read] do
          allows :index
        end

        with_wildcard_permissions { allows :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end

      with_token_authentication do
        with_permissions %w[product.read] do
          allows :index
        end

        with_wildcard_permissions { allows :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_its_product] do
      with_license_authentication do
        with_permissions %w[product.read] do
          allows :show
        end

        with_wildcard_permissions do
          denies :create, :update, :destroy
          allows :show
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end

      with_token_authentication do
        with_permissions %w[product.read] do
          allows :show
        end

        with_wildcard_permissions do
          denies :create, :update, :destroy
          allows :show
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end

    with_scenarios %i[accessing_products] do
      with_license_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end

      with_token_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_a_product] do
      with_license_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end

      with_token_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end
  end

  with_role_authorization :user do
    with_scenarios %i[with_licenses accessing_its_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          allows :index
        end

        with_wildcard_permissions { allows :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[with_licenses accessing_its_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          allows :show
        end

        with_wildcard_permissions do
          denies :create, :update, :destroy
          allows :show
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end

    with_scenarios %i[with_licenses accessing_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[with_licenses accessing_a_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end

    with_scenarios %i[accessing_products] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :index
        end

        with_wildcard_permissions { denies :index }
        with_default_permissions  { denies :index }
        without_permissions       { denies :index }
      end
    end

    with_scenarios %i[accessing_a_product] do
      with_token_authentication do
        with_permissions %w[product.read] do
          denies :show
        end

        with_wildcard_permissions do
          denies :show, :create, :update, :destroy
        end

        with_default_permissions do
          denies :show, :create, :update, :destroy
        end

        without_permissions do
          denies :show, :create, :update, :destroy
        end
      end
    end
  end

  without_authorization do
    with_scenarios %i[accessing_products] do
      without_authentication do
        denies :index
      end
    end

    with_scenarios %i[accessing_a_product] do
      without_authentication do
        denies :show, :create, :update, :destroy
      end
    end
  end
end
