class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: [ :show, :destroy, :trigger_price_sync, :edit, :update ]
  before_action :set_wear_options, only: [ :new, :edit, :create, :update ]

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
    @tracked_item.build_skinport_listing

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

  def trigger_price_sync
    steam_sync_succeeded = SteamListingSyncService.new(@tracked_item).sync
    skinport_sync_succeeded = SkinportListingSyncService.new(@tracked_item).sync

    notices = []
    alerts = []

    notices << "Skinport synced" unless not skinport_sync_succeeded
    alerts << "No (new) data for Skinport -- try again in #{ApiRequest.seconds_until_next_skinport_request} seconds" if not skinport_sync_succeeded

    notices << "Steam synced" unless not steam_sync_succeeded
    alerts << "Steam not synced" if not steam_sync_succeeded

    flash.notice = notices.join("\n") if notices.any?
    flash.alert = alerts.join("\n") if alerts.any?

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

  def set_wear_options
    wear_display_names = {
      factory_new: "Factory New",
      minimal_wear: "Minimal Wear",
      field_tested: "Field-Tested",
      well_worn: "Well-Worn",
      battle_scarred: "Battle-Scarred"
    }
    @wear_options = wear_display_names.map do |wear, display_name|
      [ display_name, wear ]
    end
  end
end
