module Api::V1::Products::Relationships
  class TokensController < Api::V1::BaseController
    before_action :scope_by_subdomain!
    before_action :authenticate_with_token!
    before_action :set_product

    def generate
      authorize @product

      token = TokenGeneratorService.new(
        account: current_account,
        bearer: @product
      ).execute

      render json: token
    end

    private

    def set_product
      @product = current_account.products.find_by_hashid params[:product_id]
    end
  end
end
