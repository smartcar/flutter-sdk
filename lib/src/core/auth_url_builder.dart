import 'dart:convert';

/// A class used for generating Smartcar Connect authorization URLs.
class AuthUrlBuilder {
  /// Set to `true` to ensure the grant approval dialog is always shown
  ///
  /// Force display of the grant approval dialog in Smartcar Connect.
  ///
  /// Defaults to false and will only display the approval dialog if the user has not previously approved the scope.
  ///
  /// Set this to `true` to ensure the approval dialog is always shown to the user even if they have previously approved the same scope.
  final bool forcePrompt;

  /// Set to `true` to ensure only a single vehicle is authorized
  ///
  /// Ensure the user only authorizes a single vehicle.<br>
  /// A user's connected service account can be connected to multiple vehicles.
  ///
  /// Setting this parameter to `true` forces the user to select only a single vehicle.
  final bool singleSelect;

  /// Set an optional state parameter
  ///
  /// An optional value included on the [SmartcarResponse](https://smartcar.github.io/android-sdk/com/smartcar/sdk/SmartcarResponse.html) object
  /// returned to the [SmartcarCallback](https://smartcar.github.io/android-sdk/com/smartcar/sdk/SmartcarCallback.html).
  final String? state;

  /// The selected make
  ///
  /// Bypass the brand selector screen to a specified make.
  ///
  /// See the available makes on the [Smartcar API Reference](https://smartcar.com/docs/api#connect-direct).
  final String? make;

  /// The specific VIN to authorize
  ///
  /// Specify the vin a user can authorize in Smartcar Connect.
  ///
  /// When the [setSingleSelect(boolean)](https://smartcar.github.io/android-sdk/com/smartcar/sdk/SmartcarAuth.AuthUrlBuilder.html#setSingleSelect-boolean-)
  /// is set to `true`, this parameter can be used to ensure that Smartcar Connect <br> will allow the user to authorize only the vehicle
  /// with a specific **VIN**.
  final String? vin;

  /// List of feature flags that your application has early access to.

  final List<String>? flags;

  /// A class used for generating Smartcar Connect authorization URLs.
  const AuthUrlBuilder({
    this.forcePrompt = false,
    this.singleSelect = false,
    this.state,
    this.make,
    this.vin,
    this.flags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forcePrompt': forcePrompt,
      'singleSelect': singleSelect,
      'state': state,
      'make': make,
      'vin': vin,
      if (flags != null) 'flags': flags,
    };
  }

  @override
  String toString() =>
      "SmartcarConfig(\nforcePrompt: $forcePrompt,\nsingleSelect: $singleSelect,\nstate: $state,\nmake: $make,\nvin: $vin\n)";

  @override
  int get hashCode => forcePrompt.hashCode ^ singleSelect.hashCode ^ state.hashCode ^ make.hashCode ^ vin.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is AuthUrlBuilder &&
        other.forcePrompt == forcePrompt &&
        other.singleSelect == singleSelect &&
        other.state == state &&
        other.make == make &&
        other.vin == vin;
  }

  factory AuthUrlBuilder.fromMap(dynamic map) {
    return AuthUrlBuilder(
      forcePrompt: map['forcePrompt'] as bool,
      singleSelect: map['singleSelect'] as bool,
      state: map['state'] != null ? map['state'] as String : null,
      make: map['make'] != null ? map['make'] as String : null,
      vin: map['vin'] != null ? map['vin'] as String : null,
      flags: map['flags'] != null ? List<String>.from((map['flags'] as List<String>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthUrlBuilder.fromJson(String source) => AuthUrlBuilder.fromMap(json.decode(source) as Map<String, dynamic>);
}
