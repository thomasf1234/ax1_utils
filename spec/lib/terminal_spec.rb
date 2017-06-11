require 'spec_helper'

module TerminalSpec
  RSpec.describe Ax1Utils::Terminal do
    let(:terminal) { Ax1Utils::Terminal.new }

    describe "#initialize" do
      it 'sets default instance variables' do
        expect(terminal.history).to eq([])
      end
    end

    describe "exec" do
      let(:commands) do
        [
            "! true",
            "echo command2",
            "echo command3"
        ]
      end

      before :each do
        allow(terminal).to receive(:last_exit_status).and_return(double(Process::Status, exitstatus: 0))
      end

      it 'executes the command and appends to history' do
        expect(terminal).to receive(:sh).with(commands[0], 1800)
        terminal.exec("! true")
        expect(terminal).to receive(:sh).with(commands[1], 1800)
        terminal.exec("echo command2")
        expect(terminal).to receive(:sh).with(commands[2], 1800)
        terminal.exec("echo command3")

        expect(terminal.history).to eq(commands)
      end

      context "unknown command" do
        let(:exception) { RuntimeError.new("Error!") }

        it 'raises an error and appends to history' do
          allow(terminal).to receive(:sh).and_raise(exception)
          expect(terminal).to receive(:on_exception).with("unknown command", exception)
          terminal.exec("unknown command")
          expect(terminal.history).to eq(["unknown command"])
        end
      end
    end

    describe '#ssh_command' do
      it 'executes the correct ssh command' do
        commands = []
        commands << terminal.ssh_command('test_user', '127.0.0.1', 22, "echo Hello")
        commands << terminal.ssh_command('test_user', '127.0.0.1', 30, "cd /opt && echo Hello")
        commands << terminal.ssh_command('test_user', '127.0.0.1', 30, "cd /opt && echo Hello", {'IdentityFile' => "/home/myuser/.ssh/id_rsa_another"})

        expected_commands = ["ssh -o LogLevel=\"quiet\" -o UserKnownHostsFile=\"/dev/null\" -o StrictHostKeyChecking=\"no\" -o NumberOfPasswordPrompts=\"0\" -o Port=\"22\" test_user@127.0.0.1 \"echo Hello\"",
                            "ssh -o LogLevel=\"quiet\" -o UserKnownHostsFile=\"/dev/null\" -o StrictHostKeyChecking=\"no\" -o NumberOfPasswordPrompts=\"0\" -o Port=\"30\" test_user@127.0.0.1 \"cd /opt && echo Hello\"",
                            "ssh -o LogLevel=\"quiet\" -o UserKnownHostsFile=\"/dev/null\" -o StrictHostKeyChecking=\"no\" -o NumberOfPasswordPrompts=\"0\" -o Port=\"30\" -o IdentityFile=\"/home/myuser/.ssh/id_rsa_another\" test_user@127.0.0.1 \"cd /opt && echo Hello\""]

        expect(commands).to eq(expected_commands)
      end
    end

    describe '#scp_command' do
      it 'executes the correct ssh command' do
        commands = []

        commands << terminal.scp_command('test_user', '127.0.0.1', 22, 'tmp/source_file', '/opt/dir/source_file')
        commands << terminal.scp_command('test_user', '127.0.0.1', 30, 'tmp/source_file', '/opt/dir/source_file', {'IdentityFile' => "/home/myuser/.ssh/id_rsa_another"})

        expected_commands = ["scp -o LogLevel=\"quiet\" -o UserKnownHostsFile=\"/dev/null\" -o StrictHostKeyChecking=\"no\" -o NumberOfPasswordPrompts=\"0\" -o Port=\"22\" tmp/source_file test_user@127.0.0.1:/opt/dir/source_file",
                            "scp -o LogLevel=\"quiet\" -o UserKnownHostsFile=\"/dev/null\" -o StrictHostKeyChecking=\"no\" -o NumberOfPasswordPrompts=\"0\" -o Port=\"30\" -o IdentityFile=\"/home/myuser/.ssh/id_rsa_another\" tmp/source_file test_user@127.0.0.1:/opt/dir/source_file"]

        expect(commands).to eq(expected_commands)
      end
    end
  end
end
