module Pagination
  extend ActiveSupport::Concern

  DEFAULT_LIMIT = 10
  DEFAULT_PAGE = 1
  MAX_LIMIT = 100

  included do
    private

    def paginate(records)
      result_key = records.model_name.plural.to_sym
      paginated_records = records.offset(offset).limit(per_page)

      {
        result_key => paginated_records,
        meta: pagination_meta(paginated_records)
      }
    end

    def offset
      (current_page - 1) * per_page
    end

    def current_page
      @current_page ||= page_param.positive? ? page_param : DEFAULT_PAGE
    end

    def page_param
      params[:page].to_i
    end

    def per_page
      @per_page ||= [(per_page_param.positive? ? per_page_param : DEFAULT_LIMIT), MAX_LIMIT].min
    end

    def per_page_param
      params[:per_page].to_i
    end

    def pagination_meta(records)
      {
        current_page: current_page,
        per_page: per_page,
        next_page: next_page(records),
        prev_page: prev_page
      }
    end

    def next_page(records)
      records.size == per_page ? current_page + 1 : nil
    end

    def prev_page
      current_page > 1 ? current_page - 1 : nil
    end
  end
end
