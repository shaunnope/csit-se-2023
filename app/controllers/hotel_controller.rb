class HotelController < ApplicationController
    include Validator

    def index
        checkInDate = params[:checkInDate]
        checkOutDate = params[:checkOutDate]
        destination = params[:destination]
        if checkInDate == nil || checkOutDate == nil || destination == nil
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

            prices = {}

            @result = []
            Hotel.where(city: destination, :date.gte => checkInDate, :date.lt => checkOutDate).each do |h|
                if prices[h.hotelName] == nil
                    prices[h.hotelName] = h.price
                else
                    prices[h.hotelName] += h.price
                end
            end

            prices.each do |k, v|
                @result << {
                    "City" => destination,
                    "Check-in Date" => checkInDate,
                    "Check-out Date" => checkOutDate,
                    "Hotel" => k,
                    "Price" => v
                }
            end

            render json: @result, status: :ok
        end
    end

    # def show
    #     @hotel = Hotel.find(params[:id])
    #     render json: @flight
    # end
end