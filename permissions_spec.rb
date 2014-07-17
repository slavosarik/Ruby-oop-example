require 'rspec'
require 'nokogiri'


class User
  def can_view?(account)
    account.member?(self)
  end

  def see_other_members(account)
    // account
  end

end

class Account
  def initialize(role)
    @list = [role]
  end

  def member?(user)
    @list.each do |pair|
      u, _ = pair
      return true if user == u
    end

    false
  end


  def

  end
  end
end

class PermissionsController # < ApplicationController
  def show # GET /permissions/:id
    p = Permission.find(params[:id])
    #current_user
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

RSpec.describe User do
  context '#can_view?' do
    it 'returns true if user member of account' do
      user = User.new
      account = Account.new([user, 'admin'])

      expect(user.can_view?(account)).to eq(true)
    end

    it 'returns true if user member of account' do
      user = User.new
      another_user = User.new
      account = Account.new([user, 'admin'])

      expect(another_user.can_view?(account)).to eq(false)
    end
  end
end

# TODO test Account#member?
