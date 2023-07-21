class HotelController < ApplicationController
    include Validator

    def index
        checkInDate = params[:checkInDate]
        checkOutDate = params[:checkOutDate]
        destination = params[:destination]
        if checkInDate.nil? || checkOutDate.nil? || destination.nil?
            render json: {error: "Missing query parameters", status: 400}, status: :bad_request
        elsif !valid_date?(checkInDate) || !valid_date?(checkOutDate)
            render json: {error: "Invalid date format", status: 400}, status: :bad_request
        else
            checkInDate = Date.parse(checkInDate)
            checkOutDate = Date.parse(checkOutDate)
            if checkInDate > checkOutDate
                render json: {error: "Check-in date cannot be later than check-out date", status: 400}, status: :bad_request
                return
            end
            
            query = Hotel.collection.aggregate([
                { "$match" => {
                    "city" => destination,
                    "date" => {"$gte" => checkInDate, "$lte" => checkOutDate}
                }},
                {
                    "$group" => {
                        "_id" => "$hotelName",
                        "price" => { "$sum" => "$price" },
                    }
                },
                { "$group" => {
                    "_id" => "$price",
                    "hotels" => { "$push" => "$_id" }
                }},
                { "$sort" => { _id: 1 }},
                { "$limit" => 1 }
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

    # def show
    #     @hotel = Hotel.find(params[:id])
    #     render json: @flight
    # end
end