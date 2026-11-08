/// Maintenance scheduling logic (module 15).
library;

class ServiceAsset {
  const ServiceAsset({
    required this.id,
    required this.name,
    required this.location,
    required this.intervalDays,
    required this.lastService,
  });

  final String id;
  final String name;
  final String location;
  final int intervalDays;
  final DateTime lastService;

  DateTime get nextDue => lastService.add(Duration(days: intervalDays));
}

enum MaintenanceStatus { ok, dueSoon, overdue }

class MaintenanceAssessment {
  const MaintenanceAssessment(
      {required this.asset, required this.status, required this.daysLeft});

  final ServiceAsset asset;
  final MaintenanceStatus status;
  final int daysLeft; // negative = overdue
}

/// Assesses one asset relative to [now].
MaintenanceAssessment assessAsset(ServiceAsset asset, DateTime now) {
  final days = asset.nextDue.difference(now).inDays;
  MaintenanceStatus status;
  if (days < 0) {
    status = MaintenanceStatus.overdue;
  } else if (days <= 7) {
    status = MaintenanceStatus.dueSoon;
  } else {
    status = MaintenanceStatus.ok;
  }
  return MaintenanceAssessment(asset: asset, status: status, daysLeft: days);
}

String statusLabel(MaintenanceStatus status) {
  switch (status) {
    case MaintenanceStatus.ok:
      return 'ok';
    case MaintenanceStatus.dueSoon:
      return 'due soon';
    case MaintenanceStatus.overdue:
      return 'overdue';
  }
}
