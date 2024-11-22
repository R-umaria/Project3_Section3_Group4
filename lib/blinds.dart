class Blinds {
  int _position = 0; // Default blinds position (0%)

  int getBlindPosition() => _position;

  void setBlindPosition(int position) {
    if (position >= 0 && position <= 100) {
      _position = position;
    }
  }
}

