module Debug
  class GraphsController < ApplicationController
    before_action { @tab = 'debug' }
    before_action :set_graph, only: [:show, :edit, :update, :destroy]

    # GET /graphs
    # GET /graphs.json
    def index
      @graphs = Graph.all.order('path ASC')
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
        @graph = Graph.find_or_create(graph_params)
        $mfclient.post_graph(@graph.path, post_params)
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
        $mfclient.edit_graph(@graph.path, update_params)
      end

      respond_to do |format|
        if success
          format.html { redirect_to graph_path(@graph), notice: 'Graph was successfully updated.' }
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
        @graph = $mfclient.delete_graph(@graph.path) rescue nil
      end
      respond_to do |format|
        format.html { redirect_to graphs_url }
        format.json { head :no_content }
      end
    end

    private

    def post_params
      # ToDo
      {:number => 0}
    end

    def update_params
      # ToDo
      {}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_graph
      @graph = Graph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def graph_params
      params.require(:graph).permit(:path, :description, :tag_list, :hidden)
    end
  end
end
