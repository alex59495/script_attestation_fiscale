#!/usr/bin/env ruby
require 'csv'
require 'mail'
require 'fileutils'

# Load .env file
require 'dotenv'
Dotenv.load('.env')

# Configuration for Gmail SMTP
GMAIL_CONFIG = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  user_name: ENV['GMAIL_EMAIL'],
  password: ENV['GMAIL_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}.freeze

def setup_mail_config
  unless ENV['GMAIL_EMAIL'] && ENV['GMAIL_PASSWORD']
    puts 'Error: Gmail credentials not found!'
    puts "\nPlease set the following environment variables: GMAIL_EMAIL and GMAIL_PASSWORD in the .env"
    puts "\nNote: Use an App Password instead of your regular password."
    puts 'Create one here: https://myaccount.google.com/apppasswords'
    exit 1
  end

  Mail.defaults do
    delivery_method :smtp, GMAIL_CONFIG
  end
end

def send_email_with_attachment(email, file_path, sender_email)
  unless File.exist?(file_path)
    puts "⚠️  File not found: #{file_path}"
    return false
  end

  filename = File.basename(file_path)

  mail = Mail.new do
    from sender_email
    to email
    subject 'Attestation fiscale 2025'
    body "Bonjour,\n\nMerci beaucoup pour votre soutien à l'assocation ANA (Association pour une Nouvelle Autonomie).\nVos dons nous permettent de mener à bien nos projets ayant pour objectif de favoriser le bien-être, l'autonomie et l’accessibilité aux espaces publics et privés des personnes à mobilité réduites dans les régions dunkerquoises et lilloises.\nVous trouverez ci-joint votre attestation fiscale pour l'année 2025. Notre association étant d'intérêt général, vos dons peuvent être déduits de votre imposition à hauteur de 66%.\n\nEn espérant vous comptez avec nous pour de nombreuses années de projets ambitieux\n\nHanna, présidente de l'association ANA"
    add_file file_path
  end

  mail.deliver!
  puts "✓ Email sent to #{email} with attachment: #{filename}"
  true
rescue => e
  puts "✗ Error sending email to #{email}: #{e.message}"
  false
end

def main
  csv_file = ARGV[0]

  unless csv_file
    puts 'Missing CSV file'
    puts 'Usage: ruby send_files_by_email.rb <csv_file>'
    puts "\nCSV format (2 columns):"
    puts '  email,chemin_fichier'
    puts '  user@example.com,/path/to/file.pdf'
    exit 1
  end

  unless File.exist?(csv_file)
    puts "Error: CSV file not found: #{csv_file}"
    exit 1
  end

  setup_mail_config
  sender_email = ENV['GMAIL_EMAIL']

  successful = 0
  failed = 0

  puts "Reading CSV file: #{csv_file}"
  puts '-' * 60

  CSV.foreach(csv_file, headers: true) do |row|
    email = row[0].strip
    file_path = row[1].strip

    if send_email_with_attachment(email, file_path, sender_email)
      successful += 1
    else
      failed += 1
    end
  end

  puts '-' * 60
  puts "Summary: #{successful} sent, #{failed} failed"
end

main if __FILE__ == $PROGRAM_NAME
