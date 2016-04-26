class ThingsController < ApplicationController
  before_action :set_thing, only: [:show, :edit, :update, :destroy]

  # GET /things
  # GET /things.json
  def index
    @things = Thing.all
  end

  # GET /things/1
  # GET /things/1.json
  def show
  end

  # GET /things/new
  def new
    @thing = Thing.new
    @p_id = get_piece_id
    @parent_p_id = "root"
  end

  # GET /things/1/edit
  def edit
  end

  # POST /things
  # POST /things.json
  def create
  ##  @thing = Thing.new(thing_params)
    @thing = Thing.new(thing_params)
    render :partial => "thing_created.js.erb", :formats => [:js]
  end

  # PATCH/PUT /things/1
  # PATCH/PUT /things/1.json
  def update
    respond_to do |format|
      if @thing.update(thing_params)
        format.html { redirect_to @thing, notice: 'Thing was successfully updated.' }
        format.json { render :show, status: :ok, location: @thing }
      else
        format.html { render :edit }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    @thing.destroy
    respond_to do |format|
      format.html { redirect_to things_url, notice: 'Thing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ##expected parameter is :parent_piece_id
  def add_field
    p = permitted_params
    @parent_p_id = p[:parent_piece_id]
    @p_id = get_piece_id
    render :partial => "piece.html.erb", :formats => [:js], :locals => {:piece_id => @p_id, :parent_piece_id => @parent_p_id}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      @thing = Thing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def thing_params
      params.require(:thing).permit(:name, :pieces => [:piece_id , :parent_piece_id])
    end

    def permitted_params
      if action_name.to_s == "add_field"
        params.permit(:parent_piece_id)
      end
    end

    def get_piece_id
      return Time.now.to_i.to_s
    end
end 
