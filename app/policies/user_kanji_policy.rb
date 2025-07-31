class UserKanjiPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    user == record.user
  end

  def create?
    user.present?
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
