class SessionManager{
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? sessionId;

  void setSessionId(String id) {
    sessionId = id;
  }

  String? getSessionId() {
    return sessionId;
  }
}