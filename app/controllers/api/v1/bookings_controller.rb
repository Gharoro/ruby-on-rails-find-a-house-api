module Api
    module V1
        class BookingsController < ApplicationController
            before_action :authorize_request, except: :create
            
            # make a new booking/enquiry
            def create
                result = Property.find(params[:property_id])
                new_booking = Booking.create(
                    first_name: bookings_params['first_name'],
                    last_name: bookings_params['last_name'],
                    email: bookings_params['email'],
                    phone: bookings_params['phone'],
                    message: bookings_params['message'],
                    property: result
                )
                
                if new_booking.valid?
                    render json: {
                        success: true,
                        message: 'Success! Your booking/enquiry has been sent.',
                        data: new_booking,
                    }, status: 201
                      
                elsif new_booking.errors.count > 0
                    render json: {
                        success: false,
                        error: new_booking.errors
                    }, status: 400    
                else
                    render json: {
                        success: false,
                        error: 'Unable to send your booking/enquiry at the moment, please try again later.',
                    }, status: 500
                end

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

            # fetch all bookings for properties belonging to logged_in user
            def index
                # returns all bookings belonging to a listing
                result = Property.find(params[:property_id]).bookings.order(created_at: :desc)
                if result.length === 0
                    render json: {
                        success: true,
                        message: "There no bookings/enquiries for this listing"
                    }, status: 200
                else
                    render json: {
                        success: true,
                        message: "Bookings / Enquiries",
                        data: result
                    }, status: 200  
                end

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

            def approve
                booking = Booking.find(params[:id])
                if booking.status == 'pending'
                    # approve booking
                    booking.status = 'approved'
                    booking.save

                    render json: {
                        success: true,
                        message: "Listing successfuly updated",
                    }, status: 200
                elsif booking.status == 'declined'
                    render json: {
                        success: false,
                        error: "Already declined!",
                    }, status: 400
                else
                    render json: {
                        success: true,
                        error: "Already approved!",
                    }, status: 400
                end

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

            # decline booking
            def decline
                booking = Booking.find(params[:id])
                if booking.status == 'pending'
                    # approve booking
                    booking.status = 'declined'
                    booking.save

                    render json: {
                        success: true,
                        message: "Listing successfuly updated",
                    }, status: 200
                elsif booking.status == 'approved'
                    render json: {
                        success: false,
                        error: "Already approved!",
                    }, status: 400
                else
                    render json: {
                        success: true,
                        error: "Already declined!",
                    }, status: 400
                end

                rescue ActiveRecord::RecordNotFound => e
                    render json: {
                        error: e.to_s,
                    }, status: :not_found
            end

    
            private
            def bookings_params
                params.permit(:first_name, :last_name, :email, :phone, :message)
            end
            
        end
    end
end
