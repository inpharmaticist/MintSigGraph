This script is dependent upon a commandline interface for Signal (see https://github.com/AsamK/signal-cli)

In short, run these commands (replace 0.6.8 if there's a new version number):

wget https://github.com/AsamK/signal-cli/releases/download/v0.6.8/signal-cli-0.6.8.tar.gz
sudo tar xf signal-cli-0.6.8.tar.gz -C /opt
sudo ln -sf /opt/signal-cli-0.6.8/bin/signal-cli /usr/local/bin/

Next, you need a phone number you can register signal to, this must be a separate number than your graphene device (or whatever device you want to RECEIVE signal messages). Google voice works. Below, "+1234567890" should be replaced with this phone number, including country code. You will receive an SMS of the verification code.

signal-cli -u +1234567890 register
signal-cli -u +1234567890 verify 1234

That's it, you're ready to send messages from a terminal to your signal-enabled device. Navigate to where these scripts reside and run the notifications.sh script.
