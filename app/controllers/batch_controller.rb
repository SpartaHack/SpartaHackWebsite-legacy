class BatchController < ApplicationController

  def create
    @batch = Batch.create()
  end

  def edit
  end

  def update
    begin
      @batch = Batch.find(:first, :params => {:token => update_params[:token]})
      p @batch
      @batch.save
      @batch.hackers.delete("#{User.current_user.first_name.capitalize} #{User.current_user.last_name.capitalize}")
    rescue => e
      p e
      @batch = nil
    end
  end

  def destroy
    @batch = Batch.find(:first, :params => {:token => params[:token]})
    @batch.destroy()
    redirect_to "/dashboard" and return
  end

  private
  def update_params
    params.require(:batch).permit(:token)
  end

  def check_login
    if !User.current_user.present?
      redirect_to '/login'
    end
  end
end
