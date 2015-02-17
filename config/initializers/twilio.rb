path = File.join(Rails.root, "config/twilio.yml")
TWILIO_CONFIG = YAML.load(File.read(path))[Rails.env] || {'sid' => '', 'from' => '', 'token' => ''}
TWILIO_ACCOUNT_SID = "ACa858959521632bb46b1e7b1ee3881ea8"
TWILIO_AUTH_TOKEN = "9d9b5dac4e2b1491fe54dbc68450c396"
TWILIO_APP_SID = "AP1911b07a66c78b475d4f2ba26e12c5bd"
TWILIO_USER_NUMBER = "+19543680565"