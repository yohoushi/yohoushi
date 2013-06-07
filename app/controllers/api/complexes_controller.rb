module Api
  class ComplexesController < ApplicationController
    # GET /complexes
    def index
      @complexes = $mgclient.list_complex
    end

    # GET /complexes/:fullpath
    def show
      @complex = $mgclient.get_complex(params[:fullpath])
    end

    # POST /complexes/:fullpath
    def create
      to_complex = create_params
      from_complexes = to_complex.delete(:data)
      @complex = $mgclient.create_complex(from_complexes, to_complex)
      render action: 'show', status: :created
    end

    # PUT /complexes/:fullpath
    def update
      # ToDo
    end

    # DELETE /complexes/:fullpath
    def destroy
      @complex = $mgclient.delete_complex(params[:fullpath])
      render action: 'show', status: :no_content
    end

    private

    def create_params
      params.require(:fullpath)
      params.require(:data)
      params.permit(:fullpath, :description, :sort, data: [ :fullpath, :gmode, :stack, :type ])
    end
  end
end
