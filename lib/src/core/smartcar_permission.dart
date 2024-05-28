/// An enum that contains all the available permissions for Smartcar.
///
/// [Available Smartcar Permissions](https://smartcar.com/docs/api/#permissions)
enum SmartcarPermission {
  /// Read VIN.
  readVin("read_vin"),

  /// Know make, model, and year.
  readVehicleInfo("read_vehicle_info"),

  /// Read detailed information from your vehicle.
  readExtendedVehicleInfo("read_extended_vehicle_info"),

  /// Retrieve total distance traveled.
  readOdometer("read_odometer"),

  /// Access location.
  readLocation("read_location"),

  /// Read fuel tank level.
  readFuel("read_fuel"),

  /// Read vehicle tire pressure.
  readTires("read_tires"),

  /// Read vehicle engine oil health.
  readEngineOil("read_engine_oil"),

  /// Lock or unlock your vehicle.
  controlSecurity("control_security"),

  /// Know the compass direction your vehicle is facing.
  readCompass("read_compass"),

  /// Know your vehicle's speed.
  readSpeedometer("read_speedometer"),

  /// Read temperatures from inside and outside the vehicle.
  readThermometer("read_thermometer"),

  /// Read EV battery's capacity and state of charge.
  readBattery("read_battery"),

  /// Know whether vehicle is charging.
  readCharge("read_charge"),

  /// Start or stop your vehicle's charging.
  controlCharge("control_charge"),

  /// Know the temperature set on your vehicle's climate control system.
  readClimate("read_climate"),

  /// Set the temperature of your vehicle's climate control system.
  controlClimate("control_climate"),

  /// Access previous charging locations and their associated charging configurations
  readChargeLocations("read_charge_locations"),

  /// Read charge records and associated billing information
  readChargeRecords("read_charge_records"),

  /// Receive notifications for events associate with charging
  readChargeEvents("read_charge_events"),

  /// Read the lock status of doors, windows, charging port, etc.
  readSecurity("read_security"),

  /// Send commands to the vehicle’s navigation system
  controlNavigation("control_navigation"),

  /// Open a vehicle’s trunk or frunk
  controlTrunk("control_trunk");

  const SmartcarPermission(this.value);

  /// The translated value for the Smartcar SDK.
  final String value;
}
