class GraphsController < ApplicationController
  # before_action :set_graph, only: [:show, :edit, :update, :destroy]

  # GET /graphs
  def index
    @graphs = $mgclient.list_graph
  rescue GrowthForecast::Error => e
    render json: {'message' => e.message}, status: :unprocessable_entity
  end

  # GET /graphs/:path
  def show
    @graph = $mgclient.get_graph(params[:path])
  rescue GrowthForecast::Error => e
    render json: {'message' => e.message}, status: :unprocessable_entity
  end

  # POST /graphs
  def create
    @graph = $mgclient.post_graph(params[:path], create_params)
    render action: 'show', status: :created
  rescue GrowthForecast::Error => e
    render json: {'message' => e.message}, status: :unprocessable_entity
  end

  # PUT /graphs/:path
  def update
    @graph = @mgclient.edit_graph(params[:path], update_params)
    render action: 'show', status: :updated
  rescue GrowthForecast::Error => e
    render json: {'message'=> e.message}, status: :unprocessable_entity
  end

  # DELETE /graphs/:path
  def destroy
    @graph = $mgclient.delete_graph(params[:path])
    render action: 'show', status: :updated
  rescue GrowthForecast::Error => e
    render json: {'message'=> e.message}, status: :unprocessable_entity
  end

  private

  def create_params
    params.permit(:number)
  end

  def update_params
    params.permit(:llimit, :mode, :stype, :meta, :gmode, :color, :ulimit, :description,
                  :sulimit, :unit, :sort, :adjust, :type, :sllimit)
  end
end
