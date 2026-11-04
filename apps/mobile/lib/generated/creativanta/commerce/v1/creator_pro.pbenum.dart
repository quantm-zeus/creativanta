// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/creator_pro.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Canonical brand deal lifecycle per M16 / S16.
class BrandDealStatus extends $pb.ProtobufEnum {
  static const BrandDealStatus BRAND_DEAL_STATUS_UNSPECIFIED =
      BrandDealStatus._(
          0, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_UNSPECIFIED');
  static const BrandDealStatus BRAND_DEAL_STATUS_NEGOTIATING =
      BrandDealStatus._(
          1, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_NEGOTIATING');
  static const BrandDealStatus BRAND_DEAL_STATUS_AGREED =
      BrandDealStatus._(2, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_AGREED');
  static const BrandDealStatus BRAND_DEAL_STATUS_IN_PROGRESS =
      BrandDealStatus._(
          3, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_IN_PROGRESS');
  static const BrandDealStatus BRAND_DEAL_STATUS_DELIVERED =
      BrandDealStatus._(4, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_DELIVERED');
  static const BrandDealStatus BRAND_DEAL_STATUS_PAID =
      BrandDealStatus._(5, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_PAID');
  static const BrandDealStatus BRAND_DEAL_STATUS_COMPLETED =
      BrandDealStatus._(6, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_COMPLETED');
  static const BrandDealStatus BRAND_DEAL_STATUS_CANCELLED =
      BrandDealStatus._(7, _omitEnumNames ? '' : 'BRAND_DEAL_STATUS_CANCELLED');

  static const $core.List<BrandDealStatus> values = <BrandDealStatus>[
    BRAND_DEAL_STATUS_UNSPECIFIED,
    BRAND_DEAL_STATUS_NEGOTIATING,
    BRAND_DEAL_STATUS_AGREED,
    BRAND_DEAL_STATUS_IN_PROGRESS,
    BRAND_DEAL_STATUS_DELIVERED,
    BRAND_DEAL_STATUS_PAID,
    BRAND_DEAL_STATUS_COMPLETED,
    BRAND_DEAL_STATUS_CANCELLED,
  ];

  static final $core.List<BrandDealStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static BrandDealStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BrandDealStatus._(super.value, super.name);
}

/// Deal type classification.
class BrandDealType extends $pb.ProtobufEnum {
  static const BrandDealType BRAND_DEAL_TYPE_UNSPECIFIED =
      BrandDealType._(0, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_UNSPECIFIED');
  static const BrandDealType BRAND_DEAL_TYPE_SPONSORED_POST = BrandDealType._(
      1, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_SPONSORED_POST');
  static const BrandDealType BRAND_DEAL_TYPE_PRODUCT_REVIEW = BrandDealType._(
      2, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_PRODUCT_REVIEW');
  static const BrandDealType BRAND_DEAL_TYPE_AMBASSADOR =
      BrandDealType._(3, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_AMBASSADOR');
  static const BrandDealType BRAND_DEAL_TYPE_AFFILIATE =
      BrandDealType._(4, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_AFFILIATE');
  static const BrandDealType BRAND_DEAL_TYPE_CUSTOM =
      BrandDealType._(5, _omitEnumNames ? '' : 'BRAND_DEAL_TYPE_CUSTOM');

  static const $core.List<BrandDealType> values = <BrandDealType>[
    BRAND_DEAL_TYPE_UNSPECIFIED,
    BRAND_DEAL_TYPE_SPONSORED_POST,
    BRAND_DEAL_TYPE_PRODUCT_REVIEW,
    BRAND_DEAL_TYPE_AMBASSADOR,
    BRAND_DEAL_TYPE_AFFILIATE,
    BRAND_DEAL_TYPE_CUSTOM,
  ];

  static final $core.List<BrandDealType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static BrandDealType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BrandDealType._(super.value, super.name);
}

/// Link in bio item type classification.
class LinkType extends $pb.ProtobufEnum {
  static const LinkType LINK_TYPE_UNSPECIFIED =
      LinkType._(0, _omitEnumNames ? '' : 'LINK_TYPE_UNSPECIFIED');
  static const LinkType LINK_TYPE_URL =
      LinkType._(1, _omitEnumNames ? '' : 'LINK_TYPE_URL');
  static const LinkType LINK_TYPE_PRODUCT =
      LinkType._(2, _omitEnumNames ? '' : 'LINK_TYPE_PRODUCT');
  static const LinkType LINK_TYPE_VIDEO =
      LinkType._(3, _omitEnumNames ? '' : 'LINK_TYPE_VIDEO');
  static const LinkType LINK_TYPE_SOCIAL =
      LinkType._(4, _omitEnumNames ? '' : 'LINK_TYPE_SOCIAL');
  static const LinkType LINK_TYPE_DOWNLOAD =
      LinkType._(5, _omitEnumNames ? '' : 'LINK_TYPE_DOWNLOAD');
  static const LinkType LINK_TYPE_EMAIL =
      LinkType._(6, _omitEnumNames ? '' : 'LINK_TYPE_EMAIL');

  static const $core.List<LinkType> values = <LinkType>[
    LINK_TYPE_UNSPECIFIED,
    LINK_TYPE_URL,
    LINK_TYPE_PRODUCT,
    LINK_TYPE_VIDEO,
    LINK_TYPE_SOCIAL,
    LINK_TYPE_DOWNLOAD,
    LINK_TYPE_EMAIL,
  ];

  static final $core.List<LinkType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static LinkType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinkType._(super.value, super.name);
}

/// Link in bio page status.
class LinkInBioPageStatus extends $pb.ProtobufEnum {
  static const LinkInBioPageStatus LINK_IN_BIO_PAGE_STATUS_UNSPECIFIED =
      LinkInBioPageStatus._(
          0, _omitEnumNames ? '' : 'LINK_IN_BIO_PAGE_STATUS_UNSPECIFIED');
  static const LinkInBioPageStatus LINK_IN_BIO_PAGE_STATUS_ACTIVE =
      LinkInBioPageStatus._(
          1, _omitEnumNames ? '' : 'LINK_IN_BIO_PAGE_STATUS_ACTIVE');
  static const LinkInBioPageStatus LINK_IN_BIO_PAGE_STATUS_SUSPENDED =
      LinkInBioPageStatus._(
          2, _omitEnumNames ? '' : 'LINK_IN_BIO_PAGE_STATUS_SUSPENDED');
  static const LinkInBioPageStatus LINK_IN_BIO_PAGE_STATUS_ARCHIVED =
      LinkInBioPageStatus._(
          3, _omitEnumNames ? '' : 'LINK_IN_BIO_PAGE_STATUS_ARCHIVED');

  static const $core.List<LinkInBioPageStatus> values = <LinkInBioPageStatus>[
    LINK_IN_BIO_PAGE_STATUS_UNSPECIFIED,
    LINK_IN_BIO_PAGE_STATUS_ACTIVE,
    LINK_IN_BIO_PAGE_STATUS_SUSPENDED,
    LINK_IN_BIO_PAGE_STATUS_ARCHIVED,
  ];

  static final $core.List<LinkInBioPageStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static LinkInBioPageStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinkInBioPageStatus._(super.value, super.name);
}

/// Link security scan and threat detection status.
class LinkSecurityScanStatus extends $pb.ProtobufEnum {
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_UNSPECIFIED =
      LinkSecurityScanStatus._(
          0, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_UNSPECIFIED');
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_SAFE =
      LinkSecurityScanStatus._(
          1, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_SAFE');
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_SUSPICIOUS =
      LinkSecurityScanStatus._(
          2, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_SUSPICIOUS');
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_PHISHING =
      LinkSecurityScanStatus._(
          3, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_PHISHING');
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_MALWARE =
      LinkSecurityScanStatus._(
          4, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_MALWARE');
  static const LinkSecurityScanStatus LINK_SECURITY_SCAN_STATUS_BLOCKED =
      LinkSecurityScanStatus._(
          5, _omitEnumNames ? '' : 'LINK_SECURITY_SCAN_STATUS_BLOCKED');

  static const $core.List<LinkSecurityScanStatus> values =
      <LinkSecurityScanStatus>[
    LINK_SECURITY_SCAN_STATUS_UNSPECIFIED,
    LINK_SECURITY_SCAN_STATUS_SAFE,
    LINK_SECURITY_SCAN_STATUS_SUSPICIOUS,
    LINK_SECURITY_SCAN_STATUS_PHISHING,
    LINK_SECURITY_SCAN_STATUS_MALWARE,
    LINK_SECURITY_SCAN_STATUS_BLOCKED,
  ];

  static final $core.List<LinkSecurityScanStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static LinkSecurityScanStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinkSecurityScanStatus._(super.value, super.name);
}

/// Media kit directory opt-in status.
class MediaKitDirectoryStatus extends $pb.ProtobufEnum {
  static const MediaKitDirectoryStatus MEDIA_KIT_DIRECTORY_STATUS_UNSPECIFIED =
      MediaKitDirectoryStatus._(
          0, _omitEnumNames ? '' : 'MEDIA_KIT_DIRECTORY_STATUS_UNSPECIFIED');
  static const MediaKitDirectoryStatus MEDIA_KIT_DIRECTORY_STATUS_HIDDEN =
      MediaKitDirectoryStatus._(
          1, _omitEnumNames ? '' : 'MEDIA_KIT_DIRECTORY_STATUS_HIDDEN');
  static const MediaKitDirectoryStatus
      MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW = MediaKitDirectoryStatus._(
          2, _omitEnumNames ? '' : 'MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW');
  static const MediaKitDirectoryStatus MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED =
      MediaKitDirectoryStatus._(
          3, _omitEnumNames ? '' : 'MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED');

  static const $core.List<MediaKitDirectoryStatus> values =
      <MediaKitDirectoryStatus>[
    MEDIA_KIT_DIRECTORY_STATUS_UNSPECIFIED,
    MEDIA_KIT_DIRECTORY_STATUS_HIDDEN,
    MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW,
    MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED,
  ];

  static final $core.List<MediaKitDirectoryStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MediaKitDirectoryStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MediaKitDirectoryStatus._(super.value, super.name);
}

/// Tax report export period.
class TaxReportPeriod extends $pb.ProtobufEnum {
  static const TaxReportPeriod TAX_REPORT_PERIOD_UNSPECIFIED =
      TaxReportPeriod._(
          0, _omitEnumNames ? '' : 'TAX_REPORT_PERIOD_UNSPECIFIED');
  static const TaxReportPeriod TAX_REPORT_PERIOD_MONTHLY =
      TaxReportPeriod._(1, _omitEnumNames ? '' : 'TAX_REPORT_PERIOD_MONTHLY');
  static const TaxReportPeriod TAX_REPORT_PERIOD_QUARTERLY =
      TaxReportPeriod._(2, _omitEnumNames ? '' : 'TAX_REPORT_PERIOD_QUARTERLY');
  static const TaxReportPeriod TAX_REPORT_PERIOD_YEARLY =
      TaxReportPeriod._(3, _omitEnumNames ? '' : 'TAX_REPORT_PERIOD_YEARLY');

  static const $core.List<TaxReportPeriod> values = <TaxReportPeriod>[
    TAX_REPORT_PERIOD_UNSPECIFIED,
    TAX_REPORT_PERIOD_MONTHLY,
    TAX_REPORT_PERIOD_QUARTERLY,
    TAX_REPORT_PERIOD_YEARLY,
  ];

  static final $core.List<TaxReportPeriod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TaxReportPeriod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaxReportPeriod._(super.value, super.name);
}

/// Tax report export format.
class TaxReportFormat extends $pb.ProtobufEnum {
  static const TaxReportFormat TAX_REPORT_FORMAT_UNSPECIFIED =
      TaxReportFormat._(
          0, _omitEnumNames ? '' : 'TAX_REPORT_FORMAT_UNSPECIFIED');
  static const TaxReportFormat TAX_REPORT_FORMAT_PDF =
      TaxReportFormat._(1, _omitEnumNames ? '' : 'TAX_REPORT_FORMAT_PDF');
  static const TaxReportFormat TAX_REPORT_FORMAT_XLSX =
      TaxReportFormat._(2, _omitEnumNames ? '' : 'TAX_REPORT_FORMAT_XLSX');
  static const TaxReportFormat TAX_REPORT_FORMAT_CSV =
      TaxReportFormat._(3, _omitEnumNames ? '' : 'TAX_REPORT_FORMAT_CSV');

  static const $core.List<TaxReportFormat> values = <TaxReportFormat>[
    TAX_REPORT_FORMAT_UNSPECIFIED,
    TAX_REPORT_FORMAT_PDF,
    TAX_REPORT_FORMAT_XLSX,
    TAX_REPORT_FORMAT_CSV,
  ];

  static final $core.List<TaxReportFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TaxReportFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaxReportFormat._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
