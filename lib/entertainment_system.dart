class EntertainmentSystem {
  int _channel = 0; // Default channel
  int _volume = 0;  // Default volume

  int getChannel() => _channel;

  void setChannel(int channel) {
    if (channel >= 0 && channel <= 100) {
      _channel = channel;
    }
  }

  int getVolume() => _volume;

  void setVolume(int volume) {
    if (volume >= 0 && volume <= 100) {
      _volume = volume;
    }
  }
}

