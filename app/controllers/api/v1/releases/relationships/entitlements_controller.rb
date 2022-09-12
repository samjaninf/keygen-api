# frozen_string_literal: true

module Api::V1::Releases::Relationships
  class EntitlementsController < Api::V1::BaseController
    before_action :scope_to_current_account!
    before_action :require_active_subscription!
    before_action :authenticate_with_token!
    before_action :set_release

    authorize :release

    def index
      authorize! release,
        with: Releases::EntitlementPolicy

      entitlements = apply_pagination(authorized_scope(apply_scopes(release.entitlements)))

      render jsonapi: entitlements
    end

    def show
      authorize! release,
        with: Releases::EntitlementPolicy

      entitlement = release.entitlements.find(params[:id])

      render jsonapi: entitlement
    end

    private

    attr_reader :release

    def set_release
      scoped_releases = authorized_scope(current_account.releases)

      @release = FindByAliasService.call(scope: scoped_releases, identifier: params[:release_id], aliases: %i[version tag])

      Current.resource = release
    end
  end
end
