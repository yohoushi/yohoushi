class GraphsController < ApplicationController
  before_action :set_tags, :set_root
  before_action :set_graph, only: [:show, :edit, :update, :destroy, :view_graph]
  before_action :set_view_options, only: [:show, :view_graph]
  before_action :path_redirect, :set_graphs, only: [:list_graph]
  before_action :autocomplete_search, only: [:autocomplete_graph]

  # GET /autocomplete_graph?term=xxx
  # for ajax autocomplete
  def autocomplete_graph
    render :json => @autocomplete.map {|node|
      description = node.description ? " (#{node.description})" : ""
      {label: "#{node.path}#{description}", value: node.path}
    }
  end

  # GET /list_graph
  def list_graph
    @units = params[:nav].try(:split, '_') || ['d', 'w'] # default: day and week
    @units = @units.to(1)
    if @root
      @display_graphs = @root.children.first.try(:graph?)
    else
      @display_graphs = false
    end
    render action: 'index'
  end

  # GET /view_graph
  def view_graph
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

  def set_view_options
    @from = params[:from].present? ? Time.parse(params[:from]) : 1.day.ago.localtime
    @to   = params[:to].present?   ? Time.parse(params[:to])   : Time.now.localtime
    @width  = Settings.graph.single_graph.width
    @height = Settings.graph.single_graph.height
  end

  def path_redirect
    return unless (path = request.query_parameters[:path])
    not_found unless (node = Node.find_by(path: path))
    if node.directory?
      redirect_to list_graph_path(path)
    else
      redirect_to view_graph_path(path)
    end
  end

  def set_tags
    @tags = Graph.tag_counts_on(:tags).order('count DESC')
  end

  def set_root
    if params[:path].present?
      @root = Node.where(path: params[:path]).first
    else
      @root = Node.roots.first
    end
    not_found unless @root
  end

  def autocomplete_search
    case
    when params[:term]
      term = params[:term].gsub(/ /, '%')
      @autocomplete = Node.select(:path, :description).where("path LIKE ?", "%#{term}%")
    else
      @autocomplete = Node.select(:path, :description).all
    end
    @autocomplete = @autocomplete.without_root.order('path ASC').limit(Settings.graph.autocomplete.limit)
  end

  def set_graphs
    case
    when params[:tag].present?
      @graphs = Graph.tagged_with(params[:tag])
    when params[:path].present?
      @graphs = Graph.where("path LIKE ?", "#{params[:path]}%")
    else
      @graphs = Graph.all
    end
    not_found if @graphs.empty?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_graph
    @graph = params[:id] ? Graph.find(params[:id]) : Graph.find_by(path: params[:path])
    not_found unless @graph
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:path, :tag_list)
  end
end
