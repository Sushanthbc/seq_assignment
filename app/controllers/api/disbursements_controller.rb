module Api
  class DisbursementsController < ApplicationController
    before_action :validate_query_params, only: [:index]

    def index
      start_date_of_week = Time.parse(params[:start_date_of_week]).beginning_of_week
      end_date_of_week = start_date_of_week.end_of_week

      # Extract to query objects in future.
      disbursements = Disbursement
                        .joins_merchant_shopper
                        .by_start_end_date_time(start_date_of_week, end_date_of_week)
                        .by_merchant_id(params[:merchant_id])
                        .select("disbursements.id", "disbursements.order_id",
                                "disbursements.final_amount", "disbursements.fee_amount",
                                "merchants.name as merchant_name", "shoppers.name as shopper_name")
      render json: disbursements, status: :ok
    end

    private

    def validate_query_params
      # Extract to filters and make extensible concern.

      if !params.has_key? :start_date_of_week
        render json: { message: "start_date_of_week is missing"}, status: :bad_request
      end
    end
  end
end
