require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:quizzes).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:games).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'provider also returns email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        context 'user already exists' do
          it 'does not create new user' do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates authorization for user' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'user does not exist' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@test.com' }) }

          it 'creates new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end

    context 'provider not returns email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'without_email', uid: '123456') }
      let(:temporary_email) { "temporary@email-#{auth.provider}-#{auth.uid}.com" }

      context 'user already exists' do
        let!(:user) { create(:user, email: temporary_email) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

        it 'returns the user with not verified email' do
          user = User.find_for_oauth(auth)
          expect(user.email_temporary?).to be_truthy
        end
      end

      context 'user does not exist' do
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user temporary email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq temporary_email
        end

        it 'returns the user with not verified email' do
          user = User.find_for_oauth(auth)
          expect(user.email_temporary?).to  be_truthy
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '#email_temporary?' do
    it 'returns true' do
      user = create(:user, email: 'temporary@email-provider-uid.com')
      expect(user.email_temporary?).to be_truthy
    end

    it 'returns false' do
      user = create(:user)
      expect(user.email_temporary?).to be_falsey
    end
  end

  describe '#author?' do
    it 'returns true' do
      user_id = rand(1..100)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: user_id)
      expect(user.author?(entity)).to be_truthy
    end

    it 'returns false' do
      user_id = rand(1..100)
      other_id = rand(200..300)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: other_id)
      expect(user.author?(entity)).to be_falsey
    end
  end

  describe '#place_in' do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz) }

    it 'returns last place in quiz' do
      5.times do |i|
        create(:rating, quiz: quiz, max_score: i + 1)
      end
      create(:rating, quiz: quiz, user: user, max_score: 0)
      expect(user.place_in(quiz)).to eq 6
    end

    it 'returns first place in quiz' do
      5.times do |i|
        create(:rating, quiz: quiz, max_score: i + 1)
      end
      create(:rating, quiz: quiz, user: user, max_score: 5)
      expect(user.place_in(quiz)).to eq 1
    end

    it 'returns place in quiz' do
      ratings = []
      5.downto(1) do |i|
        ratings << create(:rating, quiz: quiz, max_score: i * 10)
      end
      place = rand(0..5)
      create(:rating, quiz: quiz, user: user, max_score: ratings[place].max_score + 1)
      expect(user.place_in(quiz)).to eq place + 1
    end
  end
end
