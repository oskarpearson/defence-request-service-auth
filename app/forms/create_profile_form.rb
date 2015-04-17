class CreateProfileForm
  include Virtus.model
  include ActiveModel::Model

  attr :associated_user

  attribute :name, String
  attribute :tel, String
  attribute :mobile, String
  attribute :address, String
  attribute :postcode, String
  attribute :email, String
  attribute :associated_user, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :name, :tel, :mobile, :address, :postcode, :email, presence: true
  validates :password, :password_confirmation, presence: true, if: :associated_user?
  validate :verify_unique_email
  validate :matching_passwords

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def associated_user=(string_value)
    @associated_user = (string_value == '1')
  end

  private

  def persist!
    Profile.transaction do
      profile = Profile.create!(name: name,
                                tel: tel,
                                mobile: mobile,
                                address: address,
                                postcode: postcode,
                                email: email)
      User.transaction do
        if associated_user?
          profile.create_user!(email: email,
                               password: password,
                               password_confirmation: password_confirmation)
        end
        raise ActiveRecord::Rollback
      end

    end
  end

  def associated_user?
    associated_user.present? && associated_user != '0'
  end

  def verify_unique_email
    if Profile.exists? email: email
      errors.add :email, "has already been taken"
    end
  end

  def matching_passwords
    if password != password_confirmation
      errors.add :password, "does not match confirmation"
    end
  end
end
