require 'rails_helper'

RSpec.describe ShiftsController, type: :routing do
  describe 'routes ' do
    it 'does not route GET shifts to #index' do
      expect(get: 'shifts').not_to be_routable
    end

    it 'routes GET shifts/:id to #show' do
      expect(get: 'shifts/1').to route_to 'shifts#show', id: '1'
    end

    it 'routes POST shifts/:id/opt_in to #opt_in' do
      expect(post: 'shifts/1/opt_in').to route_to 'shifts#opt_in', shift_id: '1'
    end

    it 'routes DELETE shifts/:id/opt_in to #opt_out' do
      expect(delete: 'shifts/1/opt_out').to route_to 'shifts#opt_out', shift_id: '1'
    end
  end
  describe 'named routes' do
    it 'routes GET shift_path to #show' do
      expect(get: shift_path('1')).to route_to 'shifts#show', id: '1'
    end

    it 'routes POST shift_opt_in_path to #opt_in' do
      expect(post: shift_opt_in_path('1')).to route_to 'shifts#opt_in', shift_id: '1'
    end

    it 'routes DELETE shift_opt_out_path to #opt_out' do
      expect(delete: shift_opt_out_path('1')).to route_to 'shifts#opt_out', shift_id: '1'
    end
  end
end
