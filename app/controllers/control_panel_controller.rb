class ControlPanelController < ApplicationController::Base
  layout "control_panel"
  before_action :authenticate_admin!
  def index
  end

  def new
  end

  def create
  end

  def destroy
  end
end
