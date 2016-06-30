class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!

  def show
    set_ngo_event
  end

  def index
    @events = current_ngo.events.filter(*filter_params)
  end

  def new
    @event = current_ngo.new_event
  end

  def create
    @event = Event.new(event_params)
    @event.ngo = current_ngo
    if @event.save
      redirect_to [:ngos, @event], notice: t('ngos.events.messages.created_successfully')
    else
      render action: :new
    end
  end

  def edit
    @event = current_ngo.events.includes(shifts: [:users]).find(params[:id])
  end

  def update
    set_ngo_event
    if @event.update_attributes(event_params)
      redirect_to [:ngos, @event], notice: t('ngos.events.messages.updated_successfully')
    else
      render 'edit'
    end
  end

  def destroy
    set_ngo_event.destroy
    redirect_to action: :index
  end

  def publish
    set_ngo_event
    if @event.publish!
      redirect_to [:ngos, @event], notice: 'Das Event wurde erfolgreich publiziert.'
    else
      redirect_to [:ngos, @event], notice: 'Das Event konnte nicht publiziert werden.'
    end
  end

  def cal
    @event = Event.find(params[:id])
    cal = RiCal.Calendar do |cal|
      cal.event do |event|
        event.summary      = @event.title
        event.description  = @event.description
        event.dtstart      = @event.starts_at
        event.dtend        = @event.ends_at
        event.location     = @event.address
        event.url          = ngos_event_url(@event)
        event.add_attendee current_ngo.email
        event.alarm do |alarm|
          alarm.description = @event.title
        end
      end
    end
    respond_to do |format|
      format.ics { send_data(cal.export, :filename=>"cal.ics", :disposition=>"inline; filename=cal.ics", :type=>"text/calendar")}
    end
  end

  private

  def filter_params
    [
      (params[:filter_by].present? && params[:filter_by].to_sym) || nil,
      (params[:order_by].present? && params[:order_by].to_sym) || nil
    ]
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :lat, :lng,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy]
    )
  end

  def set_ngo_event
    @event = current_ngo.events.find(params[:id])
  end
end
