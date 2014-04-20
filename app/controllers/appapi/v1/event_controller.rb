class APPAPI::V1::EventController < ApplicationController
	protect_from_forgery :secret => :any_phrase,  
                       :except => :create

    before_filter :set_headers

	after_filter  :set_csrf_cookie_for_ng,
				:except => :create

	def set_csrf_cookie_for_ng
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	end

			
	def index
		# Paginated the pages so a limit amount of data is always sent to user
		@place = Place.order('created_at DESC').page(params[:page]).per_page(2)
		
		respond_to do |format|
	    	format.json { render :json => @place, :callback => params['callback'] }
	    end		
	end

=begin
	Creating new event
=end

	def create
		@place = Place.new 
		@place.location = params[:location]
		@place.description = params[:description]
		@place.place = params[:place]
		@place.date = params[:date]
		@place.time = params[:time]
		
	 	puts @place
		
		respond_to do |format|
	      if @place.save
	        # format.html { redirect_to @event.league, notice: 'Team was successfully created.' }
	        format.json { 
	        	render :json => { :status=>:success, :message=>@place },
	        	:status=>200,
	        	:callback => params['callback'] 
	        }

	      else
	        # format.html { render action: 'new' }
	        format.json { render :json=> { :status=>"Can't process info", :message=>@place.errors}, 
	        	:status=> 422, 
	        	:callback => params['callback'] 
	        }
	      end
	    end
		# if @event.save
	 #    	render :json => { :status => "success", :message => @post}, :status => 200
	 #    else
	 #     	render :json => { :status => "error", :message => "Unable to save" }, :status => 422
	 #    end
		# render :json => @place, :callback => params['callback']
	end

	private
		def event_params
	      params.require(:place).permit(:description, :location)
	    end

		def set_headers
    		if request.headers["HTTP_ORIGIN"]
    		# better way check origin
    		# if request.headers["HTTP_ORIGIN"] && /^https?:\/\/(.*)\.some\.site\.com$/i.match(request.headers["HTTP_ORIGIN"])
		      headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
		      headers['Access-Control-Expose-Headers'] = 'ETag'
		      headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
		      headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
		      headers['Access-Control-Max-Age'] = '86400'
		      headers['Access-Control-Allow-Credentials'] = 'true'
    		end
  		end

  	protected

		def verified_request?
	    	super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
	  	end
end
