class AcController < ApplicationController
  attr_accessor :cost, :tempreture
  def cost
    @cost = 0
    @errors = Array.new
    if((params[:ac][:start_temp] == "") || (params[:ac][:desired_temp] == "") || (params[:ac][:time] == ""))  then
      @errors << "Please fill all the fields"

    end
    if (params[:ac][:start_temp].match(/\D+/)) || (params[:ac][:desired_temp].match(/\D+/)) || (params[:ac][:time].match(/\D+/) || params[:ac][:start_temp].to_i <= 0 || params[:ac][:desired_temp].to_i <= 0 || params[:ac][:time].to_i <= 0)
      @errors << "Please fill the fields with time and tempreture values larger than 0"
    end
    if(@errors.length > 0) then
      redirect_to(:action => :index, :errors => @errors)
    else
      @tempreture = params[:ac][:start_temp].to_i
      @time = 0
      #If start tempreture is larger than desired tempreture range, call cooler() once, else, call heater() once to make the current tempreture to 2 degress less than desired tempreture.
      if @tempreture >= (params[:ac][:desired_temp].to_i + 2)
        @tempreture = cooler(@tempreture - params[:ac][:desired_temp].to_i - 2,@tempreture)
        @cost += 10
      elsif @tempreture < (params[:ac][:desired_temp].to_i - 2)
        @tempreture = heater(params[:ac][:desired_temp].to_i - @tempreture - 2,@tempreture)
        @cost += 10
      else
      # if we are in the acceptable range, calculate at what time the tempreture exceeds the acceptable tempreture range, call cooler()  
   
      while @time < params[:ac][:time].to_i && @tempreture < (params[:ac][:desired_temp].to_i + 2)
        @time += 1
        @tempreture += 0.5
      end
        @tempreture = cooler(@tempreture - params[:ac][:desired_temp].to_i - 2, @tempreture)
        @cost += 10
      end  
      #Starting at tempreture = desired_tempreture - 2, call cooler() once every 8 minutes.
      @time += 8
      @tempreture += 4
      while @time < params[:ac][:time].to_i
        #if room tempreture is larger than desired tempreture + 2, call cooler
        @cost += 10
        @tempreture = cooler(@tempreture - params[:ac][:desired_temp].to_i - 2, @tempreture)
        @time += 8
        @tempreture += 4
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
