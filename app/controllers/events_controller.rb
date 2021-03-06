class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    #@events = list_events
    @events = Event.all
  end

  # GET /events/1 
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @place = Place.find(@event[:place_id])
    @tickets = Ticket.where(event: @event)
    @user_ticket = UserTicket.new
    #render json: {tickets: @tickets}
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    ticket_place = Place.find(event_params["place"])
    ev_params = {}
    ev_params[:name] = event_params[:name]
    ev_params[:description] = event_params[:description]
    ev_params[:start_date] = event_params[:start_date]
    ev_params[:place] = ticket_place
    @event = Event.new(ev_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :start_date, :place)
    end

    def list_events
      event_list = []
      events = Event.all
      events.each do |event|
        event_info = event.attributes
        event_info[:place] = Place.find(event.place_id)
        event_list << event_info
      end
      event_list
    end
end
