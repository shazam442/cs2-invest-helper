class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: [ :show, :destroy, :refresh_price_overview, :edit, :update ]

  def index
    @sort_direction = params[:direction] || :asc
    @sort_column = params[:sort] || :id
    @tracked_items = TrackedItem.order(@sort_column => @sort_direction)
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @tracked_item.update(tracked_item_params)
    if @tracked_item.save
      redirect_to tracked_item_path(@tracked_item), notice: "Tracked item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @tracked_item.destroy!
    redirect_to tracked_items_path, status: :see_other, notice: "Tracked item was successfully destroyed."
  end

  def refresh_price_overview
    if @tracked_item.update_price_overviews
      flash[:notice] = "Price overview updated successfully."
    else
      flash[:alert] = "Failed to update price overview."
    end

    # Use the passed redirect path or default to the tracked item's show page
    redirect_path = params[:redirect_to].presence || tracked_item_path(@tracked_item)
    redirect_to redirect_path
  end

  private

  def tracked_item_params
    params.require(:tracked_item).permit(:name, :wear)
  end

  def set_tracked_item
    @tracked_item = TrackedItem.find_by(id: params[:id])
    unless @tracked_item
      redirect_to tracked_items_path, alert: "TrackedItem not found."
    end
  end
end
