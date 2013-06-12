class GraphsController < ApplicationController
  before_action :set_graph, only: [:show, :edit, :update, :destroy, :view_graph]
  before_action :set_graphs, :set_root, only: [:list_graph]
  before_action :set_tags

  def autocomplete_graph
    set_root
    render :json => @root.subtree.map(&:path)
  end

  # GET /list_graph
  def list_graph
    render action: 'index'
  end

  # GET /view_graph
  def view_graph
    @from = params[:from].present? ? Time.parse(params[:from]) : 1.day.ago.localtime
    @to   = params[:to].present?   ? Time.parse(params[:to])   : Time.now.localtime  
    @width  = Settings.graph.single_graph.width
    @height = Settings.graph.single_graph.height
    render action: 'show'
  end

  # GET /graphs
  # GET /graphs.json
  def index
    @graphs = Graph.all
  end

  # GET /graphs/1
  # GET /graphs/1.json
  def show
    # @ToDo same code with #view_graph
    @from = params[:from].present? ? Time.parse(params[:from]) : 1.day.ago.localtime
    @to   = params[:to].present?   ? Time.parse(params[:to])   : Time.now.localtime  
    @width  = Settings.graph.single_graph.width
    @height = Settings.graph.single_graph.height
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

  def set_tags
    @tags = Graph.tag_counts_on(:tags).order('count DESC')
  end

  def set_root
    if params[:path].present?
      @root = Node.where(path: params[:path]).first
    else
      @root = Node.root.first
    end
  end

  def set_graphs
    case
    when params[:tag]
      @graphs = Graph.tagged_with(params[:tag])
    when params[:path]
      @graphs = Graph.where("path LIKE ?", "#{params[:path]}%")
    else
      @graphs = Graph.all
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_graph
    @graph = params[:id] ? Graph.find(params[:id]) : Graph.find_by(path: params[:path])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:path, :tag_list)
  end
end
