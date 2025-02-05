#!/usr/bin/env ruby
require "stringio"
require "pact_broker/client/cli/broker"
require "pactflow/client/cli/pactflow"

ENV["THOR_COLUMNS"] = "160"
START_MARKER = "<!-- start-autogenerated-docs -->"
END_MARKER = "<!-- end-autogenerated-docs -->"
TERMINAL_WIDTH = 80

PACT_BROKER_COMMAND_GROUPS = [
  [PactBroker::Client::CLI::Broker, "Pacts", %w[publish list-latest-pact-versions] ],
  [PactBroker::Client::CLI::Broker, "Environments", %w[create-environment update-environment describe-environment delete-environment list-environments]],
  [PactBroker::Client::CLI::Broker, "Deployments", %w[record-deployment record-undeployment]],
  [PactBroker::Client::CLI::Broker, "Releases", %w[record-release record-support-ended]],
  [PactBroker::Client::CLI::Broker, "Matrix", %w[can-i-deploy can-i-merge]],
  [PactBroker::Client::CLI::Broker, "Pacticipants", %w[create-or-update-pacticipant describe-pacticipant list-pacticipants]],
  [PactBroker::Client::CLI::Broker, "Webhooks", %w[create-webhook create-or-update-webhook test-webhook]],
  [PactBroker::Client::CLI::Broker, "Tags", %w[create-version-tag]],
  [PactBroker::Client::CLI::Broker, "Versions", %w[describe-version create-or-update-version]],
  [PactBroker::Client::CLI::Broker, "Miscellaneous", %w[generate-uuid]]
]

PACTFLOW_COMMAND_GROUPS = [
  [Pactflow::Client::CLI::Pactflow, "Provider contracts (PactFlow only)", %w[publish-provider-contract]]
]

def print_wrapped(message, options = {})
  out = StringIO.new
  indent = options[:indent] || 0
  width = TERMINAL_WIDTH - indent
  paras = message.split("\n\n")

  paras.map! do |unwrapped|
    counter = 0
    unwrapped.split(" ").inject do |memo, word|
      word = word.gsub(/\n\005/, "\n").gsub(/\005/, "\n")
      counter = 0 if word.include? "\n"
      if (counter + word.length + 1) < width
        memo = "#{memo} #{word}"
        counter += (word.length + 1)
      else
        memo = "#{memo}\n#{word}"
        counter = word.length
      end
      memo
    end
  end.compact!

  paras.each do |para|
    para.split("\n").each do |line|
      out.puts line.insert(0, " " * indent)
    end
    out.puts unless para == paras.last
  end
  out.string
end

def format_banner(banner)
  banner_lines = print_wrapped(banner, indent: 16).split("\n")
  banner_lines[0] = banner_lines[0].gsub(/^\s\s/, "")
  banner_lines
end

def generate_thor_docs(command_groups)
  begin
    out = StringIO.new
    $stdout = out

    command_groups.collect do | cli, group, commands |
      puts "### #{group}\n\n"
      commands.each do | command |
        puts "#### #{command}\n\n"
        cli.start(["help", command])
        puts "\n"
      end
    end
    out.string
  ensure
    $stdout = STDOUT
  end
end

STATES = {
  start: {
    /^Usage:/ => :usage
  },
  usage: {
    /^Options:/ => :options,
  },
  options: {
    /^$/ => :after_options
  },
  after_options: {
    /^Usage:/ => :usage,
    /^  ##### / => :section_in_usage
  },
  section_in_usage: {
    /^Usage:/ => :usage
  }
}

def entered?(state)
  @old_state != state && @current_state == state
end

def exited?(state)
  @old_state == state && @current_state != state
end

def has_option_and_banner(line)
  line =~ /--.*\s#\s/
end

def has_only_banner(line)
  line =~ /^\s+#\s/
end

@current_state = :start
@old_state = nil

def reformat_docs(generated_thor_docs, command)
  generated_thor_docs.split("\n").collect do | line |
    @old_state = @current_state

    transitions = STATES[@current_state]

    line_starts_with = transitions.keys.find { | key |  line =~ key }
    if line_starts_with
      @current_state = transitions[line_starts_with]
    end

    lines = if has_option_and_banner(line)
      option, banner = line.split("#", 2)
      [option] + format_banner("# " + banner)
    elsif has_only_banner(line)
      space, banner = line.split("#", 2)
      format_banner("#  " + banner)
    elsif @current_state == :section_in_usage
      [line.strip]
    else
      [line]
    end

    if entered?(:usage) || exited?(:options)
      ["```"] + lines
    else
      lines
    end
  end
    .flatten
    .collect { | line | line.gsub(/\s+$/, "") }
    .join("\n")
    .gsub("/go/", "/")
    .gsub(File.basename(__FILE__), command)
end

def update_readme(usage_docs)
  readme_text = File.read("README.md")
  before_text = readme_text.split(START_MARKER).first
  after_text = readme_text.split("<!-- end-autogenerated-docs -->", 2).last
  new_readme_text = before_text + START_MARKER + "\n\n" + usage_docs + "\n\n" + END_MARKER + after_text
  File.open("README.md", "w") { |file| file << new_readme_text }
end

pact_broker_docs = reformat_docs(generate_thor_docs(PACT_BROKER_COMMAND_GROUPS), "pact-broker")
pactflow_docs = reformat_docs(generate_thor_docs(PACTFLOW_COMMAND_GROUPS), "pactflow")

update_readme(pact_broker_docs + "\n\n" + pactflow_docs)
