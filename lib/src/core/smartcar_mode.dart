/// Enum to be used with the mode parameter for SmartcarAuth to determine which `mode` Connect will launch in.
enum SmartcarMode {
  /// Allows users to login with a real connected services account.
  live,

  /// Allows users to connect to test vehicles using any credentials.
  test,

  /// Allows users to connect to simulated vehicles created on the Smartcar developer dashboard.
  ///
  /// 🚩 **This mode does not have effect on Android** 🚩
  simulated;
}
