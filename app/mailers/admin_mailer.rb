class AdminMailer < ApplicationMailer
  default to: proc { admins.pluck(:email) }

  def new_ngo(ngo)
    @ngo = ngo
    mail unless admins.empty?
  end

  private

  def admins
    # uses the default language
    @admins ||= User.where(admin: true)
  end
end
