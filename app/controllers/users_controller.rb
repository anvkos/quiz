class UsersController < ApplicationController
  before_action :authenticate_user!

  def ratings
    @ratings = current_user.ratings.includes(:quiz)
  end
end
