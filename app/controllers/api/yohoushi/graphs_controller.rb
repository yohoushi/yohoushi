module Api::Yohoushi
  class GraphsController < ApplicationController
    before_action :set_graph, only: [:show, :update]

    # GET /graphs
    def index
      @graphs = Graph.all.order('path ASC')
    end

    # GET /graphs/:path
    def show
    end

    # PATCH/PUT /graphs/:path
    def update
      if @graph.update(graph_params)
        render action: :show
      else
        render json: @graph.errors, status: :unprocessable_entity
      end
    end

    private

    def set_graph
      @graph = Graph.find_by_path(params[:path])
      not_found unless @graph
    end

    def graph_params
      params.permit(:description, {tag_list: []}, :visible)
    end

  end
end
