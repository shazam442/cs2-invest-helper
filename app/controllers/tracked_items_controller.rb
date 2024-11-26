class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: [ :show, :destroy, :sync_price_overview, :edit, :update ]

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
    @tracked_item.build_steam_listing

    if @tracked_item.save
      redirect_to tracked_items_path, notice: "Tracked item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tracked_item.update(tracked_item_params)
      redirect_to tracked_item_path(@tracked_item), notice: "Tracked item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @tracked_item.destroy!
    redirect_to tracked_items_path, status: :see_other, notice: "Tracked item was successfully destroyed."
  end

  def sync_price_overview
    record_updated = @tracked_item.steam_listing.sync_price_overview
    request_succeeded = record_updated && @tracked_item.steam_listing.last_request_success

    sync_request_response_code = @tracked_item.steam_listing.last_request_response_code
    sync_request_response = @tracked_item.steam_listing.last_request_response

    flash.notice = "Price Overview sync succeeded" if request_succeeded
    flash.alert = "Failed to update price overview: #{sync_request_response} (#{sync_request_response_code})" if not request_succeeded

    redirect_to request.referer
  end

  private

  def tracked_item_params
    params.require(:tracked_item).permit(:name, :wear)
  end

  def set_tracked_item
    @tracked_item = TrackedItem.find_by(id: params[:id])
    redirect_to tracked_items_path, alert: "TrackedItem not found." unless @tracked_item
  end
end
