class FlightController < ApplicationController
    include Validator

    def index
        departureDate = params[:departureDate]
        returnDate = params[:returnDate]
        destination = params[:destination]
        if departureDate == nil || returnDate == nil || destination == nil
            render json: {error: "Missing query parameters", status: 400}, status: :bad_request
        elsif !valid_date?(departureDate) || !valid_date?(returnDate)
            render json: {error: "Invalid date format", status: 400}, status: :bad_request
        else
            origin = "Singapore"
            to_flights = Flight.where(srccity: origin, destcity: destination, date: departureDate)
            from_flights = Flight.where(srccity: destination, destcity: origin, date: returnDate)

            @result = []

            to_flights.each do |t|
                from_flights.each do |f|
                    @result << {
                        # city: destination,
                        # departureDate: departureDate,
                        # departureAirline: t.airline,
                        # departurePrice: t.price,
                        
                        # returnDate: returnDate,
                        # returnAirline: f.airline,
                        # returnPrice: f.price
                        
                        "City" => destination,
                        "Departure Date" => departureDate,
                        "Departure Airline" => t.airline,
                        "Departure Price" => t.price,
                        
                        "Return Date" => returnDate,
                        "Return Airline" => f.airline,
                        "Return Price" => f.price
                    }
                end
            end

            render json: @result, status: :ok
        end
    end

    # def show
    #     @flight = Flight.find(params[:id])
    #     render json: @flight
    # end
end