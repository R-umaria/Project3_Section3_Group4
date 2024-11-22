class Locks {
  bool _isLocked = false; // Default state is unlocked

  void lock() {
    _isLocked = true;
  }

  void unlock() {
    _isLocked = false;
  }

  bool getLockStatus() => _isLocked;
}

