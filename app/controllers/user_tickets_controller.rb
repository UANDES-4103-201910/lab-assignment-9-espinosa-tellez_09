class UserTicketsController < ApplicationController
  before_action :set_user_ticket, only: [:show, :edit, :update, :destroy]

  # GET /user_tickets
  # GET /user_tickets.json
  def index
    @user_tickets = list_tickets
  end

  # GET /user_tickets/1
  # GET /user_tickets/1.json
  def show

  end

  # GET /user_tickets/new
  def new
    @user_ticket = UserTicket.new
  end

  # GET /user_tickets/1/edit
  def edit
  end

  # POST /user_tickets
  # POST /user_tickets.json
  def create    
    ticket = Ticket.find(user_ticket_params[:ticket])
    user = User.find(session["warden.user.user.key"][0][0])
    ut_params = {user: user, ticket: ticket }
    @user_ticket = UserTicket.new(ut_params)

    respond_to do |format|
      if @user_ticket.save
        format.html { redirect_to events_path, notice: 'Ticket was bought successfully.' }
        format.json { render :index, status: :created, location: @user_ticket }
      else
        format.html { render :new }
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /user_tickets/1
  # PATCH/PUT /user_tickets/1.json
  def update
    respond_to do |format|
      if @user_ticket.update(user_ticket_params)
        format.html { redirect_to @user_ticket, notice: 'User ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_ticket }
      else
        format.html { render :edit }
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_tickets/1
  # DELETE /user_tickets/1.json
  def destroy
    @user_ticket.destroy
    respond_to do |format|
      format.html { redirect_to user_tickets_url, notice: 'User ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def receipt

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ticket
      @user_ticket = UserTicket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_ticket_params
      params.require(:user_ticket).permit(:ticket, :number_of_tickets)
    end

    def list_tickets
      ticket_list = []
      user = User.find(session["warden.user.user.key"][0][0])
      tickets = UserTicket.where(paid: nil).where(user: user)
      tickets.each do |ticket|
        ticket_info = ticket.attributes
        ticket_info[:event] = Event.find(ticket.ticket.event.id)
        ticket_list << ticket_info
      end
      ticket_list
    end
end
