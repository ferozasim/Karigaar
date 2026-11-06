/// Unified User Mode Switcher
/// Enables instant role toggle between Homeowner (Customer) and Artisan (Karigaar)
enum UserRole {
  customer,
  artisan,
  admin;

  bool get isCustomer => this == UserRole.customer;
  bool get isArtisan => this == UserRole.artisan;
  bool get isAdmin => this == UserRole.admin;

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Homeowner';
      case UserRole.artisan:
        return 'Karigaar Partner';
      case UserRole.admin:
        return 'Operations Admin';
    }
  }

  String get localizedTagline {
    switch (this) {
      case UserRole.customer:
        return 'Book verified master artisans in 25 mins';
      case UserRole.artisan:
        return 'Claim nearby emergency jobs & instant IMPS wallet';
      case UserRole.admin:
        return 'HQ live telemetry & pulse stream';
    }
  }

  UserRole get toggleMode {
    if (this == UserRole.customer) return UserRole.artisan;
    if (this == UserRole.artisan) return UserRole.customer;
    return this;
  }
}
