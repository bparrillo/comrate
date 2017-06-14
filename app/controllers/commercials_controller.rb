class CommercialsController < ApplicationController
  before_action :set_commercial, only: [:show, :edit, :update, :destroy]

  def index
    @commercials = Commercial.all
  end

  def search
    if !params[:search].nil?
      @commercials = Commercial.search(params[:search])
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
    respond_to do |format|
      if @commercial.save
        format.html { redirect_to @commercial, notice: 'Commercial was successfully created.' }
        format.json { render :show, status: :created, location: @commercial }
      else
        format.html { render :new }
        format.json { render json: @commercial.errors, status: :unprocessable_entity }
      end
    end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def commercial_params
      #params.fetch(:commercial, {})
      params.require(:commercial).permit(:title, :description, :video, :search)
    end
end
