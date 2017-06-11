require 'spec_helper'

module PromptSpec
  RSpec.describe Ax1Utils::Prompt do
    let(:user_manager) { Ax1Utils::Prompt.new(is, os) }
    let(:is) { StringIO.new }
    let(:os) { StringIO.new }

    describe '#prompt_username' do
      context 'more than 2 characters inputted' do
        before :each do
          allow(is).to receive(:gets).and_return("MyUsername\n")
        end

        it 'returns the username' do
          username = user_manager.send(:prompt_username)
          expect(username).to eq("MyUsername")
        end
      end

      context 'less than 2 characters inputted' do
        before :each do
          allow(is).to receive(:gets).and_return("M\n", "Y\n", "ValidUsername\n")
        end

        it 'reprompts until a valid username is inputted' do
          username = user_manager.send(:prompt_username)
          expect(username).to eq("ValidUsername")
        end
      end
    end

    describe '#prompt_password' do
      let(:user_manager) { Ax1Utils::Prompt.new(is, os) }
      let(:is) { StringIO.new }
      let(:os) { StringIO.new }

      context 'more than 6 characters inputted' do
        context "correctly confirmed password" do
          before :each do
            allow(is).to receive(:gets).and_return("Password\n", "Password\n")
          end

          it 'returns the password' do
            password = user_manager.send(:prompt_password)
            expect(password).to eq("Password")
          end
        end

        context "correctly confirmed password after incorrect confirmations" do
          before :each do
            allow(is).to receive(:gets).and_return("Password\n", "Passwordlll\n",
                                                   "Password\n", "Passwordkkk\n",
                                                   "Password\n", "Password\n")
          end

          it 'returns the password' do
            password = user_manager.send(:prompt_password)
            expect(password).to eq("Password")
          end
        end
      end

      context 'less than 6 characters inputted' do
        before :each do
          allow(is).to receive(:gets).and_return("fj\n", "fffff\n",
                                                 "Password\n", "Passwordkkk\n",
                                                 "Password\n", "Password\n")
        end

        it 'prompts until a password is given and then confirmed' do
          password = user_manager.send(:prompt_password)
          expect(password).to eq("Password")
        end
      end
    end
  end
end
