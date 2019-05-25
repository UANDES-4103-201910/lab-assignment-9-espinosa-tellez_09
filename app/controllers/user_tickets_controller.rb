class UserTicketsController < ApplicationController
  before_action :set_user_ticket, only: [:show, :edit, :update, :destroy]

  # GET /user_tickets
  # GET /user_tickets.json
  def index
    @user_tickets = list_tickets
    #render json: {tic: @user_tickets}
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
    #us_tickets = []
    #user_ticket_params[:number_of_tickets].to_i.times do
    ticket = Ticket.find(user_ticket_params[:ticket])
    user = User.find(session["warden.user.user.key"][0][0])
    ut_params = {user: user, ticket: ticket, time: DateTime.now(), n_bought: user_ticket_params[:n_bought].to_i }
    #us_tickets << ut_params
    #end
    @user_ticket = UserTicket.new(ut_params)

    respond_to do |format|
      if @user_ticket.save
        format.html { redirect_to events_path, notice: 'Tickets were added to the cart.' }
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
      if @user_ticket.update(ut_params)
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
    @user_tickets = list_cart
  end

  def update_all
    #render json: {us: @user_tickets}
    user = User.find(session["warden.user.user.key"][0][0])
    tickets = UserTicket.where(paid: nil).where(user: user)
    tickets.each do |ticket|
      ticket.update(current: true)
    end
    respond_to do |format|
      format.html { redirect_to receipt_path, notice: 'User ticket was successfully updated.' }
      format.json { render :cart, status: :ok, location: @user_tickets }
=begin
      if @user_ticket.update(ut_params)
        format.html { redirect_to @user_ticket, notice: 'User ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_ticket }
      else
        format.html { render :edit }
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
=end
    end
  end

  def update_all_confirm
    #render json: {us: @user_tickets}
    user = User.find(session["warden.user.user.key"][0][0])
    tickets = UserTicket.where(current: true).where(user: user)
    tickets.each do |ticket|
      ticket.update(current: false, paid: true)
    end
    respond_to do |format|
      format.html { redirect_to user_tickets_path, notice: 'Tickets successfully bought.' }
      format.json { render :index, status: :ok, location: @user_tickets }
=begin
      if @user_ticket.update(ut_params)
        format.html { redirect_to @user_ticket, notice: 'User ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_ticket }
      else
        format.html { render :edit }
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
=end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ticket
      @user_ticket = UserTicket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_ticket_params
      params.require(:user_ticket).permit(:ticket, :n_bought)
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

    def list_cart
      ticket_list = [[],[]]
      total = 0
      user = User.find(session["warden.user.user.key"][0][0])
      tickets = UserTicket.where(current: true).where(user: user)
      tickets.each do |ticket|
        ticket_info = ticket.attributes
        ticket_info[:event] = Event.find(ticket.ticket.event.id)
        ticket_info[:t_price] = Ticket.find(ticket.ticket.id).price * ticket[:n_bought].to_i
        total += Ticket.find(ticket.ticket.id).price.to_i * ticket[:n_bought].to_i
        ticket_list[0] << ticket_info
      end
      ticket_list[1] = total
      ticket_list
    end

    def dup_hash(ary)
      ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
        |_k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
