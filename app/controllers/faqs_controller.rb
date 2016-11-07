class FaqsController < ApplicationController

  def index
  end

  def create
    @faq = Faq.create(faq_params)
  end

  def update
    @faq = Faq.find(faq_params[:id])
    if params[:commit] == "Update FAQ"
      @faq.load(faq_params.to_h)
      @faq.save
    elsif params[:commit] == "Delete FAQ"
      @faq.destroy()
    end
    redirect_to "/admin/faq" and return
  end

  private
  def faq_params
    params.require(:faq).permit(:question, :answer, :id)
  end
end
