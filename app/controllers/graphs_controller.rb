class GraphsController < ApplicationController
  before_action :set_graph, only: [:show, :edit, :update, :destroy]
  before_action :set_graphs, only: [:index]

  # GET /graphs
  # GET /graphs.json
  def index
  end

  # GET /graphs/1
  # GET /graphs/1.json
  def show
  end

  # GET /graphs/new
  def new
    @graph = Graph.new
  end

  # GET /graphs/1/edit
  def edit
  end

  # POST /graphs
  # POST /graphs.json
  def create
    success = ActiveRecord::Base.transaction do
      @graph = Graph.new(graph_params)
      @graph.save
      $mgclient.post_graph(@graph.path, create_params)
    end

    respond_to do |format|
      if success
        format.html { redirect_to @graph, notice: 'Graph was successfully created.' }
        format.json { render action: 'show', status: :created, location: @graph }
      else
        format.html { render action: 'new' }
        format.json { render json: @graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graphs/1
  # PATCH/PUT /graphs/1.json
  def update
    success = ActiveRecord::Base.transaction do
      @graph.update(graph_params)
      $mgclient.edit_graph(@graph.path, update_params)
    end

    respond_to do |format|
      if success
        format.html { redirect_to @graph, notice: 'Graph was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /graphs/1
  # DELETE /graphs/1.json
  def destroy
    success = ActiveRecord::Base.transaction do
      @graph.destroy
      @graph = $mgclient.delete_graph(@graph.path) rescue nil
    end
    respond_to do |format|
      format.html { redirect_to graphs_url }
      format.json { head :no_content }
    end
  end

  private

  def create_params
    {:number => 0}
  end

  def update_params
    {}
  end

  def set_graphs
    @graphs = Graph.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_graph
    @graph = Graph.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:path)
  end
end
