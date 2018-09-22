require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to have_many(:spoken_languages).dependent(:destroy) }
  it { is_expected.to have_many(:languages) }
  it { is_expected.to have_many(:qualifications).dependent(:destroy) }
  it { is_expected.to have_many(:abilities) }
  it { is_expected.to have_many(:participations).dependent(:destroy) }
  it { is_expected.to have_many(:shifts) }
  it { is_expected.to define_enum_for(:locale).with([:de, :en]) }
  it { is_expected.to act_as_paranoid }

  describe 'validations' do
    it { expect(create :user).to be_valid }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :first_name }
    it { is_expected.to validate_length_of :last_name }
    it { is_expected.to validate_acceptance_of :terms_and_conditions }
  end
  describe 'attributes' do
    let(:user) { build :user }

    it 'can be admin (default false)' do
      expect(user.admin).to be_falsy
    end
  end
  describe 'callbacks' do
    let(:user) { create :user }

    describe 'languages' do
      let(:language) { create :language }
      before { user.languages << language }

      it 'destroys join record on destroy' do
        expect{
          user.destroy
        }.to change{SpokenLanguage.count}.by -1
      end
      it 'does not destroy language record on destroy' do
        expect{
          user.destroy
        }.not_to change{Language.count}
      end
    end
    describe 'abilities' do
      let(:ability) { create :ability }
      before { user.abilities << ability }

      it 'destroys join record on destroy' do
        expect{
          user.destroy
        }.to change{Qualification.count}.by -1
      end
      it 'does not destroy ability record on destroy' do
        expect{
          user.destroy
        }.not_to change{Ability.count}
      end
    end
    describe 'shifts' do
      let(:shift) { create :shift, :skip_validate }
      before { user.shifts << shift }

      it 'destroys join record on destroy' do
        expect{
          user.destroy
        }.to change{Participation.count}.by -1
      end
      it 'does not destroy shift record on destroy' do
        expect{
          user.destroy
        }.not_to change{Shift.count}
      end
    end
  end
end
