include PayPal::SDK::REST
class CommercialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commercial, only: [:show, :edit, :update, :destroy]
  before_action :pay_params, only: [:create]
  before_action :page_default, only: [:index, :search, :my]
  before_action :authorize, only: [:edit, :update, :destroy]



  def my
    @commercials = Commercial.where(user_id: current_user.id).page(params[:page_num])
  end

  def index
    @commercials = Commercial.page(params[:page_num])
  end

  def search
    if !params[:search].nil?
      @search=params[:search]
      @commercials = Commercial.search(params[:search]).page(params[:page_num])
    else
      @commercials=[]
    end
  end

  def show
  end

  def new
    @user=current_user
    @commercial = Commercial.new
  end

  def edit
    @user=current_user
    set_commercial
  end

  def create
    @commercial = Commercial.new(commercial_params)
    @commercial.user = current_user
    pay
  end

  def update
    #vid_file = File.open(params[:commercial][:video],'wb')
    #@commercial.update!(video: vid_file)
    respond_to do |format|
      if @commercial.update!(commercial_params.merge({user: current_user}))
        format.html { redirect_to @commercial, notice: 'Commercial was successfully updated.' }
        format.json { render :show, status: :ok, location: @commercial }
      else
        format.html { render :edit }
        format.json { render json: @commercial.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commercial.destroy
    respond_to do |format|
      format.html { redirect_to commercials_url, notice: 'Commercial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def like
    vote = get_vote
    vote.value = 1 unless vote.value == 1
    vote.save
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def dislike
    vote = get_vote
    vote.value = -1 unless vote.value == -1
    vote.save
    respond_to do |format|
      format.html
      format.js 
    end
  end

  private

    def authorize
      if @commercial.user != current_user
        render json: {message: "unauthorized"}, status: 401
      end
    end

    def page_default
      if params[:page_num].nil?
        @page_num=1
      else
        @page_num=params[:page_num]
      end
    end

    def pay
      payInfo=params["commercial"]["com_payment"].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      payInfo[:type]=payInfo.delete(:card_type)
      # Build Payment object
      @payment = Payment.new({
        :intent => "sale",
        :payer => {
          :payment_method => "credit_card",
          :funding_instruments => [{
            :credit_card => payInfo
                }]},
        :transactions => [{
          :item_list => {
            :items => [{
              :name => "commercial",
              :sku => "item",
              :price => "10",
              :currency => "USD",
              :quantity => 1 }]},
          :amount => {
            :total => "10.00",
            :currency => "USD" },
          :description => "User now can post a video on website." }]})

      # Create Payment and return the status(true or false)
      respond_to do |format|
        if @payment.create
          payInfo[:card_type]=payInfo.delete(:type)
          payment = ComPayment.new(params["commercial"]["com_payment"].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}) # Payment Id
          
          if (@commercial.save && payment.update(commercial: @commercial) && payment.save)
            format.html { redirect_to @commercial, notice: 'Commercial was successfully created.' }
            format.json { render :show, status: :created, location: @commercial }
          elsif !@commercial.save
            format.html { render :new }
            format.json { render json: @commercial.errors, status: :unprocessable_entity }
          elsif !payment.update(commercial: @commercial) 
            format.html { render :new }
            format.json { render json: { "message" => "association failed"}, status: :unprocessable_entity }
          else
            format.html { render :new }
            format.json { render json: payment.errors, status: :unprocessable_entity }
          end
        else
          format.html { render :new, notice: 'Payment failed.' }
          format.json { render json: @payment.errors, status: :payment_failed }
        end
      end
    end

    def get_vote
      current_item = Commercial.find(params[:id])
      vote = current_item.votes.find_by_user_id(current_user.id)
      unless vote
        vote = Vote.create(:user_id => current_user.id, :value => 0)
        current_item.votes << vote
      end
      vote
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_commercial
      @commercial = Commercial.find(params[:id])
    end

    def pay_params
      begin
        params[:commercial][:com_payment].require(
            [:card_type, :number, :expire_month, :expire_year, :cvv2, :first_name, :last_name, :address, :city, :state,:postal_code,:country_code])
      rescue
        flash[:notice] = "missing fields"
        redirect_to action: "new"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commercial_params
      #params.fetch(:commercial, {})
      params.require(:commercial).permit(
        :page_num,
        :title,
        :description,
        :video,
        :search,
        com_payment_attributes: [
          :card_type, :number, :expire_month, :expire_year, :cvv2, :first_name, :last_name, :address, :city, :state,:postal_code,:country_code
          ]
        )
    end
end
