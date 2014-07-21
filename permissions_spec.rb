require 'rspec'
require 'nokogiri'


class User

  def initialize(id = nil)
    @id = id
  end


  def can_view?(account)
    account.member?(self)
  end

  def see_other_members(account)
    return account.members if can_view?(account)
  end

  def can_edit?(account)
    return true if account.get_role(self) == 'admin'
  end

  def get_edit_list(account)
    account.edit_list(self) if can_view?(account)
  end
end

class AdminMembership < Membership
  def can_edit?(membership)

  end
end

class Membership < Struct.new(:account, :user)

end

class Account
  def initialize(role)
    @list = role
  end

  def member?(user)
    @list.each do |pair|
      u, _ = pair
      return true if user == u
    end

    false
  end

  def members
    @list
  end

  def get_role(user)
    @list.each do |pair|
      u, role = pair
      return role if user = u
    end
  end

  def get_permission
    permissions = []

    @list.each do |pair|
      user, role = pair
      if role == 'admin'
        permissions.push([user, role, 'X'])
      else
        permissions.push([user, role, '']) unless role == 'admin'
      end
    end
    permissions
  end

  def edit_list(user)
    permissions = []

    user_role = ''

     user_membership = membership_for(user)
     permission = @list.map do |membership|
       if user_membership.can_edit?(membership)
         [membership, 'X']
        else
         [membership, 'X']
        end
     end

          #   if user_role == 'admin'
    #

    @list.each do |pair|
      u, role = pair[0], pair[1]
      user_role = role if u == user
    end


    @list.each do |pair|
      u, role = pair
      if (user == u || user_role == 'admin')
        permissions.push([u, role, 'X'])
      else
        permissions.push([u, role, ''])
      end
    end

    permissions
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

    it 'return other account members' do
      user1 = User.new(1)
      user2 = User.new(2)
      user3 = User.new(3)
      account = Account.new([[user1, 'admin'], [user2, 'member'], [user3, 'member']])

      expect(user1.see_other_members(account)).to eq([[user1, 'admin'], [user2, 'member'], [user3, 'member']])

    end

    it 'return true if user has admin role' do
      user1 = User.new(1)
      user2 = User.new(2)
      user3 = User.new(3)
      account = Account.new([[user1, 'admin'], [user2, 'member'], [user3, 'member']])

      expect(user1.can_edit?(account)).to eq(true)

    end

    it 'return role list with checkboxes' do
      user1 = User.new(1)
      user2 = User.new(2)
      user3 = User.new(3)
      account = Account.new([[user1, 'admin'], [user2, 'member'], [user3, 'member']])

      expect(account.get_permission).to eq([[user1, 'admin', 'X'], [user2, 'member', ''], [user3, 'member', '']])

    end

    it 'return list of editable members' do
      user1 = User.new(1)
      user2 = User.new(2)
      user3 = User.new(3)
      #account = Account.new([[user1, 'admin'], [user2, 'member'], [user3, 'member']])
      m1 = Membership.new(user1, account, 'admin');
      m2...
      memarray = [m1, m2]

      expect(user2.get_edit_list(account)).to eq([[user1, 'admin', ''], [user2, 'member', 'X'], [user3, 'member', '']])
    end

  end
end

# TODO test Account#member?
