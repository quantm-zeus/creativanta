// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/product.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Product catalog item classification.
class ProductType extends $pb.ProtobufEnum {
  static const ProductType PRODUCT_TYPE_UNSPECIFIED =
      ProductType._(0, _omitEnumNames ? '' : 'PRODUCT_TYPE_UNSPECIFIED');
  static const ProductType PRODUCT_TYPE_PHYSICAL =
      ProductType._(1, _omitEnumNames ? '' : 'PRODUCT_TYPE_PHYSICAL');
  static const ProductType PRODUCT_TYPE_DIGITAL =
      ProductType._(2, _omitEnumNames ? '' : 'PRODUCT_TYPE_DIGITAL');
  static const ProductType PRODUCT_TYPE_SERVICE =
      ProductType._(3, _omitEnumNames ? '' : 'PRODUCT_TYPE_SERVICE');
  static const ProductType PRODUCT_TYPE_MEMBERSHIP =
      ProductType._(4, _omitEnumNames ? '' : 'PRODUCT_TYPE_MEMBERSHIP');
  static const ProductType PRODUCT_TYPE_BUNDLE =
      ProductType._(5, _omitEnumNames ? '' : 'PRODUCT_TYPE_BUNDLE');

  static const $core.List<ProductType> values = <ProductType>[
    PRODUCT_TYPE_UNSPECIFIED,
    PRODUCT_TYPE_PHYSICAL,
    PRODUCT_TYPE_DIGITAL,
    PRODUCT_TYPE_SERVICE,
    PRODUCT_TYPE_MEMBERSHIP,
    PRODUCT_TYPE_BUNDLE,
  ];

  static final $core.List<ProductType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ProductType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProductType._(super.value, super.name);
}

/// Product catalog lifecycle status.
class CatalogStatus extends $pb.ProtobufEnum {
  static const CatalogStatus CATALOG_STATUS_UNSPECIFIED =
      CatalogStatus._(0, _omitEnumNames ? '' : 'CATALOG_STATUS_UNSPECIFIED');
  static const CatalogStatus CATALOG_STATUS_DRAFT =
      CatalogStatus._(1, _omitEnumNames ? '' : 'CATALOG_STATUS_DRAFT');
  static const CatalogStatus CATALOG_STATUS_ACTIVE =
      CatalogStatus._(2, _omitEnumNames ? '' : 'CATALOG_STATUS_ACTIVE');
  static const CatalogStatus CATALOG_STATUS_ARCHIVED =
      CatalogStatus._(3, _omitEnumNames ? '' : 'CATALOG_STATUS_ARCHIVED');
  static const CatalogStatus CATALOG_STATUS_DISCONTINUED =
      CatalogStatus._(4, _omitEnumNames ? '' : 'CATALOG_STATUS_DISCONTINUED');

  static const $core.List<CatalogStatus> values = <CatalogStatus>[
    CATALOG_STATUS_UNSPECIFIED,
    CATALOG_STATUS_DRAFT,
    CATALOG_STATUS_ACTIVE,
    CATALOG_STATUS_ARCHIVED,
    CATALOG_STATUS_DISCONTINUED,
  ];

  static final $core.List<CatalogStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CatalogStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CatalogStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
