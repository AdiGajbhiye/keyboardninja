class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    rescue_from (ActiveRecord::RecordNotFound) { |exception| handle_exception(exception, 404) }
    rescue_from (RuntimeError) { |exception| handle_exception(exception, exception.message) }

    protected
    def handle_exception(ex, status)
        render_error(ex, status)
        logger.error ex
    end

    def render_error(ex, status)
        @status_code = status
        respond_to do |format|
            format.html { render :template => "layouts/error", :status => status }
            format.all { render :nothing => true, :status => status }
         end
    end
end
