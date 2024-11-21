class TrackedItemsController < ApplicationController
  def index
    @tracked_items = TrackedItem.all
  end
  def show
  end

  def new
    @tracked_item = TrackedItem.new
  end

  def create
    @tracked_item = TrackedItem.new(tracked_item_params)
    if @tracked_item.save
      redirect_to tracked_items_path
    else
      render :new
    end
  end

  def delete
  end

  def price_data
    @tracked_item = TrackedItem.find(params[:id])
    @tracked_item.update_price_data
    redirect_to tracked_items_path, notice: "Price data updated"
  end

  private

  def tracked_item_params
    params.require(:tracked_item).permit(:item_name)
  end
end
