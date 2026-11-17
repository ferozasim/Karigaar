/// Karigaar Role Type Definition across all 10 Launch Trades
/// Represents the skill and operational hierarchy in the craftsperson ecosystem.
enum KarigaarRoleType {
  headMistry,
  skilledKarigaar,
  helperAssistant,
  thekedar;

  String get id {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return 'head_mistry';
      case KarigaarRoleType.skilledKarigaar:
        return 'skilled_karigaar';
      case KarigaarRoleType.helperAssistant:
        return 'helper_assistant';
      case KarigaarRoleType.thekedar:
        return 'thekedar';
    }
  }

  String get standardLabel {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return 'Head Mistry / Ustad';
      case KarigaarRoleType.skilledKarigaar:
        return 'Skilled Karigaar';
      case KarigaarRoleType.helperAssistant:
        return 'Helper / Bigari';
      case KarigaarRoleType.thekedar:
        return 'Thekedar / Team Contractor';
    }
  }

  String get shortLabel {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return 'Mistry';
      case KarigaarRoleType.skilledKarigaar:
        return 'Karigaar';
      case KarigaarRoleType.helperAssistant:
        return 'Helper';
      case KarigaarRoleType.thekedar:
        return 'Thekedar';
    }
  }

  String get marathiLabel {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return 'मुख्य मिस्त्री / उस्ताद';
      case KarigaarRoleType.skilledKarigaar:
        return 'कुशल कारागीर';
      case KarigaarRoleType.helperAssistant:
        return 'हेल्पर / बिगारी';
      case KarigaarRoleType.thekedar:
        return 'ठेकेदार / टीम लीडर';
    }
  }

  String get badgeText {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return '👑 Head Mistry';
      case KarigaarRoleType.skilledKarigaar:
        return '🔧 Skilled Karigaar';
      case KarigaarRoleType.helperAssistant:
        return '🤝 Helper';
      case KarigaarRoleType.thekedar:
        return '👷 Thekedar';
    }
  }

  /// Rate multiplier applied to standard labor fees
  double get rateMultiplier {
    switch (this) {
      case KarigaarRoleType.headMistry:
        return 1.25; // 25% premium for master diagnostics & supervision
      case KarigaarRoleType.skilledKarigaar:
        return 1.00; // Baseline standard rate
      case KarigaarRoleType.helperAssistant:
        return 0.65; // 35% discount for assistant/manual tasks
      case KarigaarRoleType.thekedar:
        return 1.35; // 35% team contractor rate (leads 2-5 helpers)
    }
  }

  /// Returns localized, trade-specific title for this role in the given trade
  String getLocalizedTitle(String tradeId) {
    final norm = tradeId
        .toLowerCase()
        .replaceAll('trade_', '')
        .replaceAll('-', '_');

    switch (norm) {
      case 'plumber':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Plumbing Mistry (नळ मिस्त्री)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Sanitary & Pipeline Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Plumber Helper / Bigari';
          case KarigaarRoleType.thekedar:
            return 'Plumbing Team Contractor (ठेकेदार)';
        }
      case 'mason':
      case 'mason_civil_worker':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Raj Mistry / Head Gawandi (राज मिस्त्री / गवंडी)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Tile & Plaster Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Bigari Helper';
          case KarigaarRoleType.thekedar:
            return 'Civil & Masonry Thekedar (ठेकेदार)';
        }
      case 'electrician':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Head Wireman Mistry (वायरमन मिस्त्री)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Line & Panel Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Electrical Helper';
          case KarigaarRoleType.thekedar:
            return 'Electrical Team Thekedar (ठेकेदार)';
        }
      case 'carpenter':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Sutar Mistry (सुतार मिस्त्री)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Modular Furniture Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Woodwork Helper';
          case KarigaarRoleType.thekedar:
            return 'Carpentry Team Thekedar (ठेकेदार)';
        }
      case 'painter':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Rangari Mistry (रंगारी मिस्त्री)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Putty & Texture Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Sanding Helper';
          case KarigaarRoleType.thekedar:
            return 'Painting Team Thekedar (ठेकेदार)';
        }
      case 'ac':
      case 'ac_refrig':
      case 'ac_repair':
      case 'ac_refrigeration':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Senior HVAC Mistry';
          case KarigaarRoleType.skilledKarigaar:
            return 'Gas & Cooling Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Duct/Unit Helper';
          case KarigaarRoleType.thekedar:
            return 'HVAC Team Contractor (ठेकेदार)';
        }
      case 'appliance':
      case 'appliance_repair':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Master PCB & Motor Mistry';
          case KarigaarRoleType.skilledKarigaar:
            return 'Appliance Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Diagnostic Helper';
          case KarigaarRoleType.thekedar:
            return 'Appliance Service Contractor (ठेकेदार)';
        }
      case 'welder':
      case 'welder_fabricator':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Fabrication Mistry (वेल्डिंग मिस्त्री)';
          case KarigaarRoleType.skilledKarigaar:
            return 'Arc/TIG Welder Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Grinding Helper';
          case KarigaarRoleType.thekedar:
            return 'Fabrication Team Thekedar (ठेकेदार)';
        }
      case 'pest':
      case 'pest_control':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Senior Fumigation Mistry';
          case KarigaarRoleType.skilledKarigaar:
            return 'Chemical Spray Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Safety Helper';
          case KarigaarRoleType.thekedar:
            return 'Pest Control Team Contractor (ठेकेदार)';
        }
      case 'cleaning':
      case 'deep_cleaning':
        switch (this) {
          case KarigaarRoleType.headMistry:
            return 'Cleaning Supervisor Mistry';
          case KarigaarRoleType.skilledKarigaar:
            return 'Machine Scrubbing Karigaar';
          case KarigaarRoleType.helperAssistant:
            return 'Sanitation Helper';
          case KarigaarRoleType.thekedar:
            return 'Cleaning Crew Contractor (ठेकेदार)';
        }
      default:
        return standardLabel;
    }
  }

  static KarigaarRoleType fromString(String? val) {
    if (val == null) return KarigaarRoleType.skilledKarigaar;
    final lower = val.toLowerCase();
    if (lower.contains('thekedar') || lower.contains('contractor')) {
      return KarigaarRoleType.thekedar;
    }
    if (lower.contains('mistry') ||
        lower.contains('ustad') ||
        lower.contains('head') ||
        lower.contains('master') ||
        lower.contains('senior') ||
        lower.contains('supervisor')) {
      return KarigaarRoleType.headMistry;
    }
    if (lower.contains('helper') ||
        lower.contains('bigari') ||
        lower.contains('assistant') ||
        lower.contains('sanding') ||
        lower.contains('grinding') ||
        lower.contains('sanitation')) {
      return KarigaarRoleType.helperAssistant;
    }
    return KarigaarRoleType.skilledKarigaar;
  }
}
