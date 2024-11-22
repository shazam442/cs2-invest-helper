class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: [ :show, :destroy, :price_overview_json ]

  def index
    @tracked_items = TrackedItem.order((params[:sort] || :id) => (params[:direction] || :asc))
  end
  def show
  end

  def new
    @tracked_item = TrackedItem.new
  end

  def create
    @tracked_item = TrackedItem.new(tracked_item_params)
    if @tracked_item.save
      redirect_to tracked_items_path, notice: "Tracked item was successfully created."
    else
      render :new, alert: "Failed to create tracked item."
    end
  end

  def destroy
    @tracked_item.destroy
    redirect_to tracked_items_path
  end

  def price_overview_json
    @tracked_item.update_price_overview_json
    redirect_to tracked_items_path, notice: "Price data updated"
  end

  private

  def tracked_item_params
    params.require(:tracked_item).permit(:item_name)
  end

  def set_tracked_item
    @tracked_item = TrackedItem.find_by(id: params[:id])
    unless @tracked_item
      redirect_to tracked_items_path, alert: "TrackedItem not found."
    end
  end
end
