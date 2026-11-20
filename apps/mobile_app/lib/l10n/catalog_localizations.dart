import 'package:flutter/widgets.dart';
import '../core/models/trade_model.dart';
import '../core/models/karigaar_role_type.dart';
import '../core/models/preventive_bundle_model.dart';
import 'localized_strings.dart';

String localizedTradeNameById(
        BuildContext context, String id, String fallback) =>
    localizedStrings(context).catalogTradeName(id, fallback);

String localizedTradeName(BuildContext context, TradeModel trade) =>
    localizedTradeNameById(context, trade.tradeId, trade.name);

String localizedTradeTagline(BuildContext context, TradeModel trade) =>
    localizedTradeTaglineById(context, trade.tradeId, trade.tagline);

String localizedTradeTaglineById(
  BuildContext context,
  String id,
  String fallback,
) =>
    localizedStrings(context).catalogTradeTagline(id, fallback);

String localizedPackageName(
        BuildContext context, ServicePackageModel package) =>
    localizedStrings(context)
        .catalogPackageName(package.packageId, package.name);

String localizedPackageDescription(
        BuildContext context, ServicePackageModel package) =>
    localizedStrings(context)
        .catalogPackageDescription(package.packageId, package.description);

String localizedBundleTitle(
        BuildContext context, PreventiveBundleModel bundle) =>
    localizedStrings(context).catalogBundleTitle(bundle.bundleId, bundle.title);

String localizedBundleSubtitle(
        BuildContext context, PreventiveBundleModel bundle) =>
    localizedStrings(context)
        .catalogBundleSubtitle(bundle.bundleId, bundle.subtitle);

String localizedBundleDiscount(
        BuildContext context, PreventiveBundleModel bundle) =>
    Localizations.localeOf(context).languageCode == 'en'
        ? bundle.discountTag
        : localizedStrings(context)
            .sharedSavePercent(bundle.computedDiscountPercent);

String localizedBundleTask(
        BuildContext context, PreventiveBundleModel bundle, int index) =>
    localizedStrings(context).catalogBundleTask(
        '${bundle.bundleId}_$index', bundle.includedTasks[index]);

String localizedRoleName(BuildContext context, KarigaarRoleType role) =>
    localizedStrings(context).catalogRoleName(role.name, role.standardLabel);

String localizedRoleBadge(BuildContext context, KarigaarRoleType role) =>
    localizedStrings(context).catalogRoleBadge(role.name, role.badgeText);

String localizedRoleTitle(
        BuildContext context, KarigaarRoleType role, String tradeId) =>
    Localizations.localeOf(context).languageCode == 'en'
        ? role.getLocalizedTitle(tradeId)
        : '${localizedRoleName(context, role)} • ${localizedTradeNameById(context, tradeId, tradeId)}';
