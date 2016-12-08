#require_relative '../models/vote.rb'
class CommercialsController < ApplicationController
  before_action :set_commercial, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  #skip_before_filter :verify_authenticity_token

  # GET /commercials
  # GET /commercials.json
  def index
    @commercials = Commercial.all
  end

  def search
    if !params[:search].nil?
      @commercials = Commercial.search(params[:search])
    end
  end

  # GET /commercials/1
  # GET /commercials/1.json
  def show
  end

  # GET /commercials/new
  def new
    @commercial = Commercial.new
  end

  # GET /commercials/1/edit
  def edit
    set_commercial
  end

  # POST /commercials
  # POST /commercials.json
  def create
    @commercial = Commercial.new(commercial_params)
    #@commercial.user= User.first
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

  # PATCH/PUT /commercials/1
  # PATCH/PUT /commercials/1.json
  def update
    #vid_file = File.open(params[:commercial][:video],'wb')
    #@commercial.update!(video: vid_file)
    respond_to do |format|
      if @commercial.update(commercial_params)
        format.html { redirect_to @commercial, notice: 'Commercial was successfully updated.' }
        format.json { render :show, status: :ok, location: @commercial }
      else
        format.html { render :edit }
        format.json { render json: @commercial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commercials/1
  # DELETE /commercials/1.json
  def destroy
    @commercial.destroy
    respond_to do |format|
      format.html { redirect_to commercials_url, notice: 'Commercial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def like
    get_vote
    @vote.value = 1 unless @vote.value == 1
    @vote.save
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def dislike
    get_vote
    @vote.value = -1 unless @vote.value == -1
    @vote.save
    respond_to do |format|
      format.html
      format.js 
    end
  end

  private

    def get_vote
      current_item = Commercial.find(params[:id])
      @vote = current_item.votes.find_by_user_id(current_user.id)
      unless @vote
        @vote = Vote.create(:user_id => current_user.id, :value => 0)
        current_item.votes << @vote
      end
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
