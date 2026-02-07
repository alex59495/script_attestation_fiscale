# Email Script Setup Guide

## Prerequisites

1. **Ruby** (version 2.3+)
2. **Mail gem**

## Installation

### 1. Install required gems

```bash
gem install mail dotenv
```

Or if using Bundler, add to Gemfile:
```ruby
gem 'mail'
gem 'dotenv'
```

Then run `bundle install`

### 2. Gmail Setup

For Gmail SMTP (free solution):

#### If you have 2-Factor Authentication enabled (recommended):
1. Go to [Google Account](https://myaccount.google.com)
2. Navigate to **Security** → **App passwords**
3. Select "Mail" and "Linux"
4. Copy the generated 16-character password

#### If you don't have 2FA enabled:
1. You can use your regular Gmail password
2. However, Google may block "less secure app access" - enable it if needed at [Less secure apps](https://myaccount.google.com/lesssecureapps)

### 3. Set Environment Variables

Before running the script, set your Gmail credentials:

```bash
export GMAIL_EMAIL="your-email@gmail.com"
export GMAIL_PASSWORD="your-app-password-or-regular-password"
```

Or create a `.env` file:
```bash
GMAIL_EMAIL=your-email@gmail.com
GMAIL_PASSWORD=your-app-password-or-regular-password
```

Then load it: `source .env`

## Usage

### 1. Create your CSV file

Format: `email,path_to_file`

Example (`emails.csv`):
```csv
email,path_to_file
john@example.com,/path/to/document1.pdf
jane@example.com,./files/document2.pdf
```

### 2. Run the script

```bash
ruby send_files_by_email.rb emails.csv
```

## Example Output

```
Reading CSV file: emails.csv
------------------------------------------------------------
✓ Email sent to john@example.com with attachment: document1.pdf
✓ Email sent to jane@example.com with attachment: document2.pdf
------------------------------------------------------------
Summary: 2 sent, 0 failed
```

## Troubleshooting

### "Gmail credentials not found"
- Make sure you've set `GMAIL_EMAIL` and `GMAIL_PASSWORD` environment variables
- Check with: `echo $GMAIL_EMAIL`

### "Authentication failed"
- Verify you're using an App Password (if 2FA enabled), not your regular password
- Check that the password is correct

### "File not found"
- Verify the file paths in your CSV are absolute or relative paths that exist
- The script will show which files it couldn't find

### "Connection refused"
- Check your internet connection
- SMTP server `smtp.gmail.com` port 587 must be accessible

## Security Notes

⚠️ **Never commit your `.env` file** - add it to `.gitignore`

```bash
echo ".env" >> .gitignore
```

For production, consider using:
- Environment variable management services
- Secure credential vaults
- Service-specific API keys instead of passwords
