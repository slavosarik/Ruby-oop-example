require 'rspec'
require 'nokogiri'

class User

end

class Account

end

class PermissionsController # < ApplicationController
  def show # GET /permissions/:id
    p = Permission.find(params[:id])
    current_user
  end

  def index # GET /permissions
    #zobrazenie zoznamu
    # ak prihlaseny user ma pravo vidiet konto tak to zobrazim inak error
    unless current_user.can_view?(current_account)
      redirect_to_root_path
    end

  end

  def create

  end

  def current_user
    User.find()
  end

  def current_account
    Account.find(params[:account_id])
  end

end

RSpec.describe Test do
  it 'permission_test' do

    #vytvorit fake pouzivatela
    #vytvorit ho s accountom
    #zistit prava
    #overit ak ma vytvoreny account, ta

  end

end
