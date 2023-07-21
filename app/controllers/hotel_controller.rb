class HotelController < ApplicationController
    include Validator

    def index
        # Validate query parameters
        checkInDate = valid_date?(params[:checkInDate])
        checkOutDate = valid_date?(params[:checkOutDate])
        destination = params[:destination]
        missing = %w(checkInDate checkOutDate destination).select { |param| params[param].nil? }
        if missing.length > 0
            render json: {
                    error: "Missing query parameters", 
                    status: 400,
                    missing: missing
                }, status: :bad_request
            return
        elsif !checkInDate || !checkOutDate
            render json: {
                    error: "Invalid date format", 
                    status: 400,
                    checkInDate: checkInDate,
                    checkOutDate: checkOutDate
                }, status: :bad_request
            return
        end

        if checkInDate > checkOutDate
            render json: {error: "Check-in date cannot be later than check-out date", status: 400}, status: :bad_request
            return
        end
        
        # Query database
        query = Hotel.collection.aggregate([
            { "$match" => {
                "city" => destination,
                "date" => {"$gte" => checkInDate, "$lte" => checkOutDate}
            }},
            # compute total price for each hotel for the entire stay
            { "$group" => {
                    "_id" => "$hotelName",
                    "price" => { "$sum" => "$price" },
                }
            },
            # collect all hotels with the same price
            { "$group" => {
                "_id" => "$price",
                "hotels" => { "$push" => "$_id" }
            }},
            { "$sort" => { _id: 1 }},
            { "$limit" => 1 } # get the cheapest hotels
        ])

        @result = []
        query.each do |min_price|
            p min_price
            min_price["hotels"].each do |h|
                @result << {
                    "City" => destination,
                    "Check In Date" => checkInDate,
                    "Check Out Date" => checkOutDate,
                    "Hotel" => h,
                    "Price" => min_price["_id"]
                }
            end
        end
        render json: @result, status: :ok
    end
end