module Api
  class ComplexesController < ApplicationController
    # GET /complexes
    def index
      @complexes = $mgclient.list_complex
    end

    # GET /complexes/:path
    def show
      @complex = $mgclient.get_complex(params[:path])
    end

    # POST /complexes/:path
    def create
      to_complex = create_params
      from_complexes = to_complex.delete(:data)
      @complex = $mgclient.create_complex(from_complexes, to_complex)
      render action: 'show', status: :created
    end

    # PUT /complexes/:path
    def update
      # ToDo
    end

    # DELETE /complexes/:path
    def destroy
      @complex = $mgclient.delete_complex(params[:path])
      render action: 'show', status: :no_content
    end

    private

    def create_params
      params.require(:path)
      params.require(:data)
      params.permit(:path, :description, :sort, data: [ :path, :gmode, :stack, :type ])
    end
  end
end
