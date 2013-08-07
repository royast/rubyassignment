class AcController < ApplicationController
  attr_accessor :cost, :temperature
  def cost
    @cost = 0
    @errors = Array.new
    if((params[:ac][:start_temp] == "") || (params[:ac][:desired_temp] == "") || (params[:ac][:time] == ""))  then
      @errors << "Please fill all the fields"

    end
    if (params[:ac][:start_temp].match(/\D+/)) || (params[:ac][:desired_temp].match(/\D+/)) || (params[:ac][:time].match(/\D+/) || params[:ac][:start_temp].to_i <= 0 || params[:ac][:desired_temp].to_i <= 0 || params[:ac][:time].to_i <= 0)
      @errors << "Please fill the fields with time and temperature values larger than 0"
    end
    if(@errors.length > 0) then
      redirect_to(:action => :index, :errors => @errors)
    else
      @temperature = params[:ac][:start_temp].to_i
      @time = 0
      #If start temperature is larger than desired temperature range, call cooler() once, else, call heater() once to make the current temperature to 2 degress less than desired temperature.
      if @temperature >= (params[:ac][:desired_temp].to_i + 2)
        @temperature = cooler(@temperature - params[:ac][:desired_temp].to_i - 2,@temperature)
        @cost += 10
      elsif @temperature < (params[:ac][:desired_temp].to_i - 2)
        @temperature = heater(params[:ac][:desired_temp].to_i - @temperature - 2,@temperature)
        @cost += 10
      else
      # if we are in the acceptable range, calculate at what time the temperature exceeds the acceptable temperature range, call cooler()  
   
      while @time < params[:ac][:time].to_i && @temperature < (params[:ac][:desired_temp].to_i + 2)
        @time += 1
        @temperature += 0.5
      end
        @temperature = cooler(@temperature - params[:ac][:desired_temp].to_i - 2, @temperature)
        @cost += 10
      end  
      #Starting at temperature = desired_temperature - 2, call cooler() once every 8 minutes.
      @time += 8
      @temperature += 4
      while @time < params[:ac][:time].to_i
        #if room temperature is larger than desired temperature + 2, call cooler
        @cost += 10
        @temperature = cooler(@temperature - params[:ac][:desired_temp].to_i - 2, @temperature)
        @time += 8
        @temperature += 4
      end

    end
  end

  private

  def cooler(deg,tmp)
    tmp -= deg
  end

  def heater(deg,tmp)
    tmp  += deg
  end
end
