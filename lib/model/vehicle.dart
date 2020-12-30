class DRTVehicle {
  final String regNum;
  final String make = 'Proton';
  final String model = 'Iriz';
  DateTime expiryDate;
  bool autoRenew = false;

  DRTVehicle(this.regNum, String date) : this.expiryDate = DateTime.parse(date);

  DRTVehicle.add(this.regNum) : this.expiryDate = DateTime.now();

  int daysLeft() {
    return expiryDate.difference(DateTime.now()).inDays; // TODO: fix wrong calculation (right now, less than one day considered expired)
  }
}