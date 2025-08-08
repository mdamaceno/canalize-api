class LabelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_label, only: [:update, :destroy]

  def index
    labels = current_user.labels.all

    ok_response(labels.map { |label| LabelSerializer.new(label).as_json })
  end

  def create
    label = current_user.labels.new(label_params)

    return ok_response(LabelSerializer.new(label).as_json, status: :created) if label.save

    error_response(label.errors.full_messages)
  end

  def update
    return ok_response(LabelSerializer.new(@label).as_json, status: :ok) if @label.update(label_params)

    error_response(@label.errors.full_messages)
  end

  def destroy
    @label.destroy
    head :no_content
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = current_user.labels.find_by(identifier: params[:id])
  end
end
