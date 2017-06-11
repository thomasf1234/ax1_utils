require 'spec_helper'

module ShellExceptionSpec
  RSpec.describe Ax1Utils::ShellException do
    let(:shell_exception) { Ax1Utils::ShellException.new(exit_status, command) }
    let(:exit_status) { double(Process::Status, pid: 123, exitstatus: 1) }
    let(:command) { "/usr/bin/some_command" }

    describe "#inheritance" do
      it 'is a kind of RuntimeError' do
        expect(shell_exception.kind_of?(RuntimeError)).to eq(true)
      end
    end

    describe "#pid" do
      it "returns the pid" do
        expect(shell_exception.pid).to eq(123)
      end
    end

    describe "#exitstatus" do
      it "returns the exitstatus" do
        expect(shell_exception.exitstatus).to eq(1)
      end
    end

    describe "#command" do
      it "returns the command that caused the exception" do
        expect(shell_exception.command).to eq("/usr/bin/some_command")
      end
    end
  end
end

