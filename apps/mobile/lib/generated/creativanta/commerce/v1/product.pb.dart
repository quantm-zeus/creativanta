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
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import '../../common/v1/types.pb.dart' as $1;
import 'product.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'product.pbenum.dart';

/// External reference link for a product or SKU on a connected commerce platform.
class ExternalRef extends $pb.GeneratedMessage {
  factory ExternalRef({
    $core.String? platform,
    $core.String? externalId,
    $core.String? url,
    $core.String? connectedAccountId,
  }) {
    final result = ExternalRef._();
    if (platform != null) result.platform = platform;
    if (externalId != null) result.externalId = externalId;
    if (url != null) result.url = url;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    return result;
  }

  ExternalRef._();

  factory ExternalRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExternalRef()..mergeFromBuffer(data, registry);
  factory ExternalRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExternalRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExternalRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ExternalRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'externalId')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aOS(4, _omitFieldNames ? '' : 'connectedAccountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExternalRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExternalRef copyWith(void Function(ExternalRef) updates) =>
      super.copyWith((message) => updates(message as ExternalRef))
          as ExternalRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExternalRef() / ExternalRef.new instead')
  static ExternalRef create() => ExternalRef._();
  static $pb.GeneratedMessage $_createMessage() => ExternalRef._();
  @$core.override
  ExternalRef createEmptyInstance() => ExternalRef._();
  @$core.pragma('dart2js:noInline')
  static ExternalRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalRef>(
          ExternalRef.$_createMessage);
  static ExternalRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get externalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set externalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExternalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearExternalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get connectedAccountId => $_getSZ(3);
  @$pb.TagNumber(4)
  set connectedAccountId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConnectedAccountId() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectedAccountId() => $_clearField(4);
}

/// Canonical SKU variant under a product.
class ProductSku extends $pb.GeneratedMessage {
  factory ProductSku({
    $core.String? skuId,
    $core.String? workspaceId,
    $core.String? productId,
    $core.String? skuCode,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        variantAttributes,
    $1.Money? priceOverride,
    $1.Money? cogsOverride,
    $core.String? currency,
    $core.int? stockQuantity,
    $core.int? stockReserved,
    $core.int? lowStockThreshold,
    $core.String? barcode,
    $core.int? weightGrams,
    $core.bool? isActive,
    $core.Iterable<ExternalRef>? externalRefs,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $2.Timestamp? deletedAt,
  }) {
    final result = ProductSku._();
    if (skuId != null) result.skuId = skuId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (productId != null) result.productId = productId;
    if (skuCode != null) result.skuCode = skuCode;
    if (variantAttributes != null)
      result.variantAttributes.addEntries(variantAttributes);
    if (priceOverride != null) result.priceOverride = priceOverride;
    if (cogsOverride != null) result.cogsOverride = cogsOverride;
    if (currency != null) result.currency = currency;
    if (stockQuantity != null) result.stockQuantity = stockQuantity;
    if (stockReserved != null) result.stockReserved = stockReserved;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    if (barcode != null) result.barcode = barcode;
    if (weightGrams != null) result.weightGrams = weightGrams;
    if (isActive != null) result.isActive = isActive;
    if (externalRefs != null) result.externalRefs.addAll(externalRefs);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  ProductSku._();

  factory ProductSku.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductSku()..mergeFromBuffer(data, registry);
  factory ProductSku.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductSku()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductSku',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ProductSku.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'skuCode')
    ..m<$core.String, $core.String>(
        5, _omitFieldNames ? '' : 'variantAttributes',
        entryClassName: 'ProductSku.VariantAttributesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.commerce.v1'))
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'priceOverride',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'cogsOverride',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aI(9, _omitFieldNames ? '' : 'stockQuantity')
    ..aI(10, _omitFieldNames ? '' : 'stockReserved')
    ..aI(11, _omitFieldNames ? '' : 'lowStockThreshold')
    ..aOS(12, _omitFieldNames ? '' : 'barcode')
    ..aI(13, _omitFieldNames ? '' : 'weightGrams')
    ..aOB(14, _omitFieldNames ? '' : 'isActive')
    ..pPM<ExternalRef>(15, _omitFieldNames ? '' : 'externalRefs',
        subBuilder: ExternalRef.$_createMessage)
    ..aOM<$2.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(18, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductSku clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductSku copyWith(void Function(ProductSku) updates) =>
      super.copyWith((message) => updates(message as ProductSku)) as ProductSku;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProductSku() / ProductSku.new instead')
  static ProductSku create() => ProductSku._();
  static $pb.GeneratedMessage $_createMessage() => ProductSku._();
  @$core.override
  ProductSku createEmptyInstance() => ProductSku._();
  @$core.pragma('dart2js:noInline')
  static ProductSku getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductSku>(ProductSku.$_createMessage);
  static ProductSku? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get skuCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set skuCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSkuCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearSkuCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get variantAttributes => $_getMap(4);

  @$pb.TagNumber(6)
  $1.Money get priceOverride => $_getN(5);
  @$pb.TagNumber(6)
  set priceOverride($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPriceOverride() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriceOverride() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensurePriceOverride() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get cogsOverride => $_getN(6);
  @$pb.TagNumber(7)
  set cogsOverride($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCogsOverride() => $_has(6);
  @$pb.TagNumber(7)
  void clearCogsOverride() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureCogsOverride() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get stockQuantity => $_getIZ(8);
  @$pb.TagNumber(9)
  set stockQuantity($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStockQuantity() => $_has(8);
  @$pb.TagNumber(9)
  void clearStockQuantity() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get stockReserved => $_getIZ(9);
  @$pb.TagNumber(10)
  set stockReserved($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStockReserved() => $_has(9);
  @$pb.TagNumber(10)
  void clearStockReserved() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get lowStockThreshold => $_getIZ(10);
  @$pb.TagNumber(11)
  set lowStockThreshold($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLowStockThreshold() => $_has(10);
  @$pb.TagNumber(11)
  void clearLowStockThreshold() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get barcode => $_getSZ(11);
  @$pb.TagNumber(12)
  set barcode($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBarcode() => $_has(11);
  @$pb.TagNumber(12)
  void clearBarcode() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get weightGrams => $_getIZ(12);
  @$pb.TagNumber(13)
  set weightGrams($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasWeightGrams() => $_has(12);
  @$pb.TagNumber(13)
  void clearWeightGrams() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isActive => $_getBF(13);
  @$pb.TagNumber(14)
  set isActive($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsActive() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsActive() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<ExternalRef> get externalRefs => $_getList(14);

  @$pb.TagNumber(16)
  $2.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($2.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $2.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($2.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $2.Timestamp ensureUpdatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $2.Timestamp get deletedAt => $_getN(17);
  @$pb.TagNumber(18)
  set deletedAt($2.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasDeletedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearDeletedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $2.Timestamp ensureDeletedAt() => $_ensure(17);
}

/// Canonical Product entity in the M13 catalog.
class Product extends $pb.GeneratedMessage {
  factory Product({
    $core.String? productId,
    $core.String? workspaceId,
    ProductType? productType,
    $core.String? title,
    $core.String? description,
    $core.String? category,
    $1.Money? basePrice,
    $core.String? currency,
    $1.Money? cogs,
    CatalogStatus? catalogStatus,
    $core.bool? inventoryEnabled,
    $core.Iterable<ExternalRef>? externalRefs,
    $core.Iterable<$core.String>? images,
    $core.String? metadataJson,
    $core.Iterable<ProductSku>? skus,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $2.Timestamp? deletedAt,
  }) {
    final result = Product._();
    if (productId != null) result.productId = productId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (productType != null) result.productType = productType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (category != null) result.category = category;
    if (basePrice != null) result.basePrice = basePrice;
    if (currency != null) result.currency = currency;
    if (cogs != null) result.cogs = cogs;
    if (catalogStatus != null) result.catalogStatus = catalogStatus;
    if (inventoryEnabled != null) result.inventoryEnabled = inventoryEnabled;
    if (externalRefs != null) result.externalRefs.addAll(externalRefs);
    if (images != null) result.images.addAll(images);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (skus != null) result.skus.addAll(skus);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  Product._();

  factory Product.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Product()..mergeFromBuffer(data, registry);
  factory Product.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Product()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Product',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Product.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ProductType>(3, _omitFieldNames ? '' : 'productType',
        enumValues: ProductType.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'category')
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'basePrice',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aOM<$1.Money>(9, _omitFieldNames ? '' : 'cogs',
        subBuilder: $1.Money.$_createMessage)
    ..aE<CatalogStatus>(10, _omitFieldNames ? '' : 'catalogStatus',
        enumValues: CatalogStatus.values)
    ..aOB(11, _omitFieldNames ? '' : 'inventoryEnabled')
    ..pPM<ExternalRef>(12, _omitFieldNames ? '' : 'externalRefs',
        subBuilder: ExternalRef.$_createMessage)
    ..pPS(13, _omitFieldNames ? '' : 'images')
    ..aOS(14, _omitFieldNames ? '' : 'metadataJson')
    ..pPM<ProductSku>(15, _omitFieldNames ? '' : 'skus',
        subBuilder: ProductSku.$_createMessage)
    ..aOM<$2.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(18, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Product clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Product copyWith(void Function(Product) updates) =>
      super.copyWith((message) => updates(message as Product)) as Product;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Product() / Product.new instead')
  static Product create() => Product._();
  static $pb.GeneratedMessage $_createMessage() => Product._();
  @$core.override
  Product createEmptyInstance() => Product._();
  @$core.pragma('dart2js:noInline')
  static Product getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Product>(Product.$_createMessage);
  static Product? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  ProductType get productType => $_getN(2);
  @$pb.TagNumber(3)
  set productType(ProductType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProductType() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get category => $_getSZ(5);
  @$pb.TagNumber(6)
  set category($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategory() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Money get basePrice => $_getN(6);
  @$pb.TagNumber(7)
  set basePrice($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBasePrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearBasePrice() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureBasePrice() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Money get cogs => $_getN(8);
  @$pb.TagNumber(9)
  set cogs($1.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCogs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCogs() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Money ensureCogs() => $_ensure(8);

  @$pb.TagNumber(10)
  CatalogStatus get catalogStatus => $_getN(9);
  @$pb.TagNumber(10)
  set catalogStatus(CatalogStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCatalogStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearCatalogStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get inventoryEnabled => $_getBF(10);
  @$pb.TagNumber(11)
  set inventoryEnabled($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInventoryEnabled() => $_has(10);
  @$pb.TagNumber(11)
  void clearInventoryEnabled() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<ExternalRef> get externalRefs => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get images => $_getList(12);

  @$pb.TagNumber(14)
  $core.String get metadataJson => $_getSZ(13);
  @$pb.TagNumber(14)
  set metadataJson($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasMetadataJson() => $_has(13);
  @$pb.TagNumber(14)
  void clearMetadataJson() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<ProductSku> get skus => $_getList(14);

  @$pb.TagNumber(16)
  $2.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($2.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $2.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($2.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $2.Timestamp ensureUpdatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $2.Timestamp get deletedAt => $_getN(17);
  @$pb.TagNumber(18)
  set deletedAt($2.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasDeletedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearDeletedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $2.Timestamp ensureDeletedAt() => $_ensure(17);
}

/// Linked content item reference.
class ContentRef extends $pb.GeneratedMessage {
  factory ContentRef({
    $core.String? contentId,
    $core.String? contentType,
    $core.String? title,
    $core.String? url,
    $2.Timestamp? linkedAt,
    $core.String? metadataJson,
  }) {
    final result = ContentRef._();
    if (contentId != null) result.contentId = contentId;
    if (contentType != null) result.contentType = contentType;
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    if (linkedAt != null) result.linkedAt = linkedAt;
    if (metadataJson != null) result.metadataJson = metadataJson;
    return result;
  }

  ContentRef._();

  factory ContentRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContentRef()..mergeFromBuffer(data, registry);
  factory ContentRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContentRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContentRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ContentRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'contentId')
    ..aOS(2, _omitFieldNames ? '' : 'contentType')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'linkedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentRef copyWith(void Function(ContentRef) updates) =>
      super.copyWith((message) => updates(message as ContentRef)) as ContentRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContentRef() / ContentRef.new instead')
  static ContentRef create() => ContentRef._();
  static $pb.GeneratedMessage $_createMessage() => ContentRef._();
  @$core.override
  ContentRef createEmptyInstance() => ContentRef._();
  @$core.pragma('dart2js:noInline')
  static ContentRef getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContentRef>(ContentRef.$_createMessage);
  static ContentRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set contentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearContentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentType => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get linkedAt => $_getN(4);
  @$pb.TagNumber(5)
  set linkedAt($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLinkedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLinkedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureLinkedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get metadataJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set metadataJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMetadataJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadataJson() => $_clearField(6);
}

class CreateRequest extends $pb.GeneratedMessage {
  factory CreateRequest({
    $1.CommandContext? context,
    ProductType? productType,
    $core.String? title,
    $core.String? description,
    $core.String? category,
    $1.Money? basePrice,
    $1.Money? cogs,
    $core.String? currency,
    CatalogStatus? catalogStatus,
    $core.bool? inventoryEnabled,
    $core.Iterable<ExternalRef>? externalRefs,
    $core.Iterable<$core.String>? images,
    $core.String? metadataJson,
    $core.Iterable<ProductSku>? initialSkus,
  }) {
    final result = CreateRequest._();
    if (context != null) result.context = context;
    if (productType != null) result.productType = productType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (category != null) result.category = category;
    if (basePrice != null) result.basePrice = basePrice;
    if (cogs != null) result.cogs = cogs;
    if (currency != null) result.currency = currency;
    if (catalogStatus != null) result.catalogStatus = catalogStatus;
    if (inventoryEnabled != null) result.inventoryEnabled = inventoryEnabled;
    if (externalRefs != null) result.externalRefs.addAll(externalRefs);
    if (images != null) result.images.addAll(images);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (initialSkus != null) result.initialSkus.addAll(initialSkus);
    return result;
  }

  CreateRequest._();

  factory CreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRequest()..mergeFromBuffer(data, registry);
  factory CreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aE<ProductType>(2, _omitFieldNames ? '' : 'productType',
        enumValues: ProductType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'basePrice',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'cogs',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aE<CatalogStatus>(9, _omitFieldNames ? '' : 'catalogStatus',
        enumValues: CatalogStatus.values)
    ..aOB(10, _omitFieldNames ? '' : 'inventoryEnabled')
    ..pPM<ExternalRef>(11, _omitFieldNames ? '' : 'externalRefs',
        subBuilder: ExternalRef.$_createMessage)
    ..pPS(12, _omitFieldNames ? '' : 'images')
    ..aOS(13, _omitFieldNames ? '' : 'metadataJson')
    ..pPM<ProductSku>(14, _omitFieldNames ? '' : 'initialSkus',
        subBuilder: ProductSku.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest copyWith(void Function(CreateRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRequest))
          as CreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateRequest() / CreateRequest.new instead')
  static CreateRequest create() => CreateRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateRequest._();
  @$core.override
  CreateRequest createEmptyInstance() => CreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRequest>(
          CreateRequest.$_createMessage);
  static CreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  ProductType get productType => $_getN(1);
  @$pb.TagNumber(2)
  set productType(ProductType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProductType() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Money get basePrice => $_getN(5);
  @$pb.TagNumber(6)
  set basePrice($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBasePrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearBasePrice() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureBasePrice() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get cogs => $_getN(6);
  @$pb.TagNumber(7)
  set cogs($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCogs() => $_has(6);
  @$pb.TagNumber(7)
  void clearCogs() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureCogs() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  CatalogStatus get catalogStatus => $_getN(8);
  @$pb.TagNumber(9)
  set catalogStatus(CatalogStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCatalogStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearCatalogStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get inventoryEnabled => $_getBF(9);
  @$pb.TagNumber(10)
  set inventoryEnabled($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInventoryEnabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearInventoryEnabled() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<ExternalRef> get externalRefs => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get images => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get metadataJson => $_getSZ(12);
  @$pb.TagNumber(13)
  set metadataJson($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMetadataJson() => $_has(12);
  @$pb.TagNumber(13)
  void clearMetadataJson() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<ProductSku> get initialSkus => $_getList(13);
}

class CreateResponse extends $pb.GeneratedMessage {
  factory CreateResponse({
    Product? product,
  }) {
    final result = CreateResponse._();
    if (product != null) result.product = product;
    return result;
  }

  CreateResponse._();

  factory CreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateResponse()..mergeFromBuffer(data, registry);
  factory CreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateResponse.$_createMessage)
    ..aOM<Product>(1, _omitFieldNames ? '' : 'product',
        subBuilder: Product.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateResponse copyWith(void Function(CreateResponse) updates) =>
      super.copyWith((message) => updates(message as CreateResponse))
          as CreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateResponse() / CreateResponse.new instead')
  static CreateResponse create() => CreateResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateResponse._();
  @$core.override
  CreateResponse createEmptyInstance() => CreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateResponse>(
          CreateResponse.$_createMessage);
  static CreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Product get product => $_getN(0);
  @$pb.TagNumber(1)
  set product(Product value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);
  @$pb.TagNumber(1)
  Product ensureProduct() => $_ensure(0);
}

class GetRequest extends $pb.GeneratedMessage {
  factory GetRequest({
    $core.String? productId,
  }) {
    final result = GetRequest._();
    if (productId != null) result.productId = productId;
    return result;
  }

  GetRequest._();

  factory GetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRequest()..mergeFromBuffer(data, registry);
  factory GetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequest copyWith(void Function(GetRequest) updates) =>
      super.copyWith((message) => updates(message as GetRequest)) as GetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetRequest() / GetRequest.new instead')
  static GetRequest create() => GetRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRequest._();
  @$core.override
  GetRequest createEmptyInstance() => GetRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequest>(GetRequest.$_createMessage);
  static GetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);
}

class GetResponse extends $pb.GeneratedMessage {
  factory GetResponse({
    Product? product,
  }) {
    final result = GetResponse._();
    if (product != null) result.product = product;
    return result;
  }

  GetResponse._();

  factory GetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetResponse()..mergeFromBuffer(data, registry);
  factory GetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetResponse.$_createMessage)
    ..aOM<Product>(1, _omitFieldNames ? '' : 'product',
        subBuilder: Product.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetResponse copyWith(void Function(GetResponse) updates) =>
      super.copyWith((message) => updates(message as GetResponse))
          as GetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetResponse() / GetResponse.new instead')
  static GetResponse create() => GetResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetResponse._();
  @$core.override
  GetResponse createEmptyInstance() => GetResponse._();
  @$core.pragma('dart2js:noInline')
  static GetResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetResponse>(
          GetResponse.$_createMessage);
  static GetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Product get product => $_getN(0);
  @$pb.TagNumber(1)
  set product(Product value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);
  @$pb.TagNumber(1)
  Product ensureProduct() => $_ensure(0);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $1.Pagination? pagination,
    CatalogStatus? statusFilter,
    ProductType? typeFilter,
    $core.String? categoryFilter,
    $core.String? searchQuery,
  }) {
    final result = ListRequest._();
    if (pagination != null) result.pagination = pagination;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (typeFilter != null) result.typeFilter = typeFilter;
    if (categoryFilter != null) result.categoryFilter = categoryFilter;
    if (searchQuery != null) result.searchQuery = searchQuery;
    return result;
  }

  ListRequest._();

  factory ListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromBuffer(data, registry);
  factory ListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOM<$1.Pagination>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aE<CatalogStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: CatalogStatus.values)
    ..aE<ProductType>(3, _omitFieldNames ? '' : 'typeFilter',
        enumValues: ProductType.values)
    ..aOS(4, _omitFieldNames ? '' : 'categoryFilter')
    ..aOS(5, _omitFieldNames ? '' : 'searchQuery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest copyWith(void Function(ListRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequest))
          as ListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRequest() / ListRequest.new instead')
  static ListRequest create() => ListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRequest._();
  @$core.override
  ListRequest createEmptyInstance() => ListRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRequest>(
          ListRequest.$_createMessage);
  static ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Pagination get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($1.Pagination value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Pagination ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  CatalogStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(CatalogStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  ProductType get typeFilter => $_getN(2);
  @$pb.TagNumber(3)
  set typeFilter(ProductType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTypeFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearTypeFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get categoryFilter => $_getSZ(3);
  @$pb.TagNumber(4)
  set categoryFilter($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategoryFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategoryFilter() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get searchQuery => $_getSZ(4);
  @$pb.TagNumber(5)
  set searchQuery($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearchQuery() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearchQuery() => $_clearField(5);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<Product>? products,
    $1.PaginatedResponse? pagination,
  }) {
    final result = ListResponse._();
    if (products != null) result.products.addAll(products);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPM<Product>(1, _omitFieldNames ? '' : 'products',
        subBuilder: Product.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListResponse() / ListResponse.new instead')
  static ListResponse create() => ListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => ListResponse._();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListResponse>(
          ListResponse.$_createMessage);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Product> get products => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePagination() => $_ensure(1);
}

class UpdateRequest extends $pb.GeneratedMessage {
  factory UpdateRequest({
    $1.CommandContext? context,
    $core.String? productId,
    $core.String? title,
    $core.String? description,
    $core.String? category,
    $1.Money? basePrice,
    $1.Money? cogs,
    CatalogStatus? catalogStatus,
    $core.bool? inventoryEnabled,
    $core.Iterable<ExternalRef>? externalRefs,
    $core.Iterable<$core.String>? images,
    $core.String? metadataJson,
  }) {
    final result = UpdateRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (category != null) result.category = category;
    if (basePrice != null) result.basePrice = basePrice;
    if (cogs != null) result.cogs = cogs;
    if (catalogStatus != null) result.catalogStatus = catalogStatus;
    if (inventoryEnabled != null) result.inventoryEnabled = inventoryEnabled;
    if (externalRefs != null) result.externalRefs.addAll(externalRefs);
    if (images != null) result.images.addAll(images);
    if (metadataJson != null) result.metadataJson = metadataJson;
    return result;
  }

  UpdateRequest._();

  factory UpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRequest()..mergeFromBuffer(data, registry);
  factory UpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'basePrice',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'cogs',
        subBuilder: $1.Money.$_createMessage)
    ..aE<CatalogStatus>(8, _omitFieldNames ? '' : 'catalogStatus',
        enumValues: CatalogStatus.values)
    ..aOB(9, _omitFieldNames ? '' : 'inventoryEnabled')
    ..pPM<ExternalRef>(10, _omitFieldNames ? '' : 'externalRefs',
        subBuilder: ExternalRef.$_createMessage)
    ..pPS(11, _omitFieldNames ? '' : 'images')
    ..aOS(12, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRequest copyWith(void Function(UpdateRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRequest))
          as UpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateRequest() / UpdateRequest.new instead')
  static UpdateRequest create() => UpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateRequest._();
  @$core.override
  UpdateRequest createEmptyInstance() => UpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRequest>(
          UpdateRequest.$_createMessage);
  static UpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Money get basePrice => $_getN(5);
  @$pb.TagNumber(6)
  set basePrice($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBasePrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearBasePrice() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureBasePrice() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get cogs => $_getN(6);
  @$pb.TagNumber(7)
  set cogs($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCogs() => $_has(6);
  @$pb.TagNumber(7)
  void clearCogs() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureCogs() => $_ensure(6);

  @$pb.TagNumber(8)
  CatalogStatus get catalogStatus => $_getN(7);
  @$pb.TagNumber(8)
  set catalogStatus(CatalogStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCatalogStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearCatalogStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get inventoryEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set inventoryEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInventoryEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearInventoryEnabled() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<ExternalRef> get externalRefs => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get images => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get metadataJson => $_getSZ(11);
  @$pb.TagNumber(12)
  set metadataJson($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMetadataJson() => $_has(11);
  @$pb.TagNumber(12)
  void clearMetadataJson() => $_clearField(12);
}

class UpdateResponse extends $pb.GeneratedMessage {
  factory UpdateResponse({
    Product? product,
  }) {
    final result = UpdateResponse._();
    if (product != null) result.product = product;
    return result;
  }

  UpdateResponse._();

  factory UpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateResponse()..mergeFromBuffer(data, registry);
  factory UpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateResponse.$_createMessage)
    ..aOM<Product>(1, _omitFieldNames ? '' : 'product',
        subBuilder: Product.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateResponse copyWith(void Function(UpdateResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateResponse))
          as UpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateResponse() / UpdateResponse.new instead')
  static UpdateResponse create() => UpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateResponse._();
  @$core.override
  UpdateResponse createEmptyInstance() => UpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateResponse>(
          UpdateResponse.$_createMessage);
  static UpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Product get product => $_getN(0);
  @$pb.TagNumber(1)
  set product(Product value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);
  @$pb.TagNumber(1)
  Product ensureProduct() => $_ensure(0);
}

class DeleteRequest extends $pb.GeneratedMessage {
  factory DeleteRequest({
    $1.CommandContext? context,
    $core.String? productId,
  }) {
    final result = DeleteRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    return result;
  }

  DeleteRequest._();

  factory DeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRequest()..mergeFromBuffer(data, registry);
  factory DeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: DeleteRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRequest copyWith(void Function(DeleteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRequest))
          as DeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteRequest() / DeleteRequest.new instead')
  static DeleteRequest create() => DeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteRequest._();
  @$core.override
  DeleteRequest createEmptyInstance() => DeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRequest>(
          DeleteRequest.$_createMessage);
  static DeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);
}

class DeleteResponse extends $pb.GeneratedMessage {
  factory DeleteResponse({
    $core.bool? success,
  }) {
    final result = DeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  DeleteResponse._();

  factory DeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteResponse()..mergeFromBuffer(data, registry);
  factory DeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: DeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse copyWith(void Function(DeleteResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteResponse))
          as DeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteResponse() / DeleteResponse.new instead')
  static DeleteResponse create() => DeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteResponse._();
  @$core.override
  DeleteResponse createEmptyInstance() => DeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteResponse>(
          DeleteResponse.$_createMessage);
  static DeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ArchiveRequest extends $pb.GeneratedMessage {
  factory ArchiveRequest({
    $1.CommandContext? context,
    $core.String? productId,
  }) {
    final result = ArchiveRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    return result;
  }

  ArchiveRequest._();

  factory ArchiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveRequest()..mergeFromBuffer(data, registry);
  factory ArchiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ArchiveRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRequest copyWith(void Function(ArchiveRequest) updates) =>
      super.copyWith((message) => updates(message as ArchiveRequest))
          as ArchiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArchiveRequest() / ArchiveRequest.new instead')
  static ArchiveRequest create() => ArchiveRequest._();
  static $pb.GeneratedMessage $_createMessage() => ArchiveRequest._();
  @$core.override
  ArchiveRequest createEmptyInstance() => ArchiveRequest._();
  @$core.pragma('dart2js:noInline')
  static ArchiveRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArchiveRequest>(
          ArchiveRequest.$_createMessage);
  static ArchiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);
}

class ArchiveResponse extends $pb.GeneratedMessage {
  factory ArchiveResponse({
    Product? product,
  }) {
    final result = ArchiveResponse._();
    if (product != null) result.product = product;
    return result;
  }

  ArchiveResponse._();

  factory ArchiveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveResponse()..mergeFromBuffer(data, registry);
  factory ArchiveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ArchiveResponse.$_createMessage)
    ..aOM<Product>(1, _omitFieldNames ? '' : 'product',
        subBuilder: Product.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveResponse copyWith(void Function(ArchiveResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveResponse))
          as ArchiveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArchiveResponse() / ArchiveResponse.new instead')
  static ArchiveResponse create() => ArchiveResponse._();
  static $pb.GeneratedMessage $_createMessage() => ArchiveResponse._();
  @$core.override
  ArchiveResponse createEmptyInstance() => ArchiveResponse._();
  @$core.pragma('dart2js:noInline')
  static ArchiveResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArchiveResponse>(
          ArchiveResponse.$_createMessage);
  static ArchiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Product get product => $_getN(0);
  @$pb.TagNumber(1)
  set product(Product value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);
  @$pb.TagNumber(1)
  Product ensureProduct() => $_ensure(0);
}

class BatchTagRequest extends $pb.GeneratedMessage {
  factory BatchTagRequest({
    $1.CommandContext? context,
    $core.Iterable<$core.String>? productIds,
    $core.Iterable<$core.String>? tagsToAdd,
    $core.Iterable<$core.String>? tagsToRemove,
  }) {
    final result = BatchTagRequest._();
    if (context != null) result.context = context;
    if (productIds != null) result.productIds.addAll(productIds);
    if (tagsToAdd != null) result.tagsToAdd.addAll(tagsToAdd);
    if (tagsToRemove != null) result.tagsToRemove.addAll(tagsToRemove);
    return result;
  }

  BatchTagRequest._();

  factory BatchTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchTagRequest()..mergeFromBuffer(data, registry);
  factory BatchTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchTagRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BatchTagRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'productIds')
    ..pPS(3, _omitFieldNames ? '' : 'tagsToAdd')
    ..pPS(4, _omitFieldNames ? '' : 'tagsToRemove')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchTagRequest copyWith(void Function(BatchTagRequest) updates) =>
      super.copyWith((message) => updates(message as BatchTagRequest))
          as BatchTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BatchTagRequest() / BatchTagRequest.new instead')
  static BatchTagRequest create() => BatchTagRequest._();
  static $pb.GeneratedMessage $_createMessage() => BatchTagRequest._();
  @$core.override
  BatchTagRequest createEmptyInstance() => BatchTagRequest._();
  @$core.pragma('dart2js:noInline')
  static BatchTagRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BatchTagRequest>(
          BatchTagRequest.$_createMessage);
  static BatchTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get productIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get tagsToAdd => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tagsToRemove => $_getList(3);
}

class BatchTagResponse extends $pb.GeneratedMessage {
  factory BatchTagResponse({
    $core.int? updatedCount,
  }) {
    final result = BatchTagResponse._();
    if (updatedCount != null) result.updatedCount = updatedCount;
    return result;
  }

  BatchTagResponse._();

  factory BatchTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchTagResponse()..mergeFromBuffer(data, registry);
  factory BatchTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchTagResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BatchTagResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'updatedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchTagResponse copyWith(void Function(BatchTagResponse) updates) =>
      super.copyWith((message) => updates(message as BatchTagResponse))
          as BatchTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BatchTagResponse() / BatchTagResponse.new instead')
  static BatchTagResponse create() => BatchTagResponse._();
  static $pb.GeneratedMessage $_createMessage() => BatchTagResponse._();
  @$core.override
  BatchTagResponse createEmptyInstance() => BatchTagResponse._();
  @$core.pragma('dart2js:noInline')
  static BatchTagResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BatchTagResponse>(
          BatchTagResponse.$_createMessage);
  static BatchTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get updatedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set updatedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdatedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedCount() => $_clearField(1);
}

class ImportRowResult extends $pb.GeneratedMessage {
  factory ImportRowResult({
    $core.int? rowNumber,
    $core.String? sourceId,
    $core.String? title,
    $core.String? action,
    $core.String? errorMessage,
    $core.String? productId,
    $core.String? skuCode,
  }) {
    final result = ImportRowResult._();
    if (rowNumber != null) result.rowNumber = rowNumber;
    if (sourceId != null) result.sourceId = sourceId;
    if (title != null) result.title = title;
    if (action != null) result.action = action;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (productId != null) result.productId = productId;
    if (skuCode != null) result.skuCode = skuCode;
    return result;
  }

  ImportRowResult._();

  factory ImportRowResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRowResult()..mergeFromBuffer(data, registry);
  factory ImportRowResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRowResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportRowResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ImportRowResult.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'rowNumber')
    ..aOS(2, _omitFieldNames ? '' : 'sourceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(6, _omitFieldNames ? '' : 'productId')
    ..aOS(7, _omitFieldNames ? '' : 'skuCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRowResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRowResult copyWith(void Function(ImportRowResult) updates) =>
      super.copyWith((message) => updates(message as ImportRowResult))
          as ImportRowResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportRowResult() / ImportRowResult.new instead')
  static ImportRowResult create() => ImportRowResult._();
  static $pb.GeneratedMessage $_createMessage() => ImportRowResult._();
  @$core.override
  ImportRowResult createEmptyInstance() => ImportRowResult._();
  @$core.pragma('dart2js:noInline')
  static ImportRowResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportRowResult>(
          ImportRowResult.$_createMessage);
  static ImportRowResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rowNumber => $_getIZ(0);
  @$pb.TagNumber(1)
  set rowNumber($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRowNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearRowNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get productId => $_getSZ(5);
  @$pb.TagNumber(6)
  set productId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProductId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProductId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get skuCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set skuCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSkuCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearSkuCode() => $_clearField(7);
}

class ImportRequest extends $pb.GeneratedMessage {
  factory ImportRequest({
    $1.CommandContext? context,
    $core.String? sourcePlatform,
    $core.String? connectedAccountId,
    $core.String? rawData,
    $core.String? fileName,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? columnMappings,
    $core.String? defaultCurrency,
    $core.bool? previewOnly,
    $core.String? previewToken,
    $core.bool? dryRun,
  }) {
    final result = ImportRequest._();
    if (context != null) result.context = context;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (rawData != null) result.rawData = rawData;
    if (fileName != null) result.fileName = fileName;
    if (columnMappings != null)
      result.columnMappings.addEntries(columnMappings);
    if (defaultCurrency != null) result.defaultCurrency = defaultCurrency;
    if (previewOnly != null) result.previewOnly = previewOnly;
    if (previewToken != null) result.previewToken = previewToken;
    if (dryRun != null) result.dryRun = dryRun;
    return result;
  }

  ImportRequest._();

  factory ImportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRequest()..mergeFromBuffer(data, registry);
  factory ImportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ImportRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(3, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOS(4, _omitFieldNames ? '' : 'rawData')
    ..aOS(5, _omitFieldNames ? '' : 'fileName')
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'columnMappings',
        entryClassName: 'ImportRequest.ColumnMappingsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.commerce.v1'))
    ..aOS(7, _omitFieldNames ? '' : 'defaultCurrency')
    ..aOB(8, _omitFieldNames ? '' : 'previewOnly')
    ..aOS(9, _omitFieldNames ? '' : 'previewToken')
    ..aOB(10, _omitFieldNames ? '' : 'dryRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRequest copyWith(void Function(ImportRequest) updates) =>
      super.copyWith((message) => updates(message as ImportRequest))
          as ImportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportRequest() / ImportRequest.new instead')
  static ImportRequest create() => ImportRequest._();
  static $pb.GeneratedMessage $_createMessage() => ImportRequest._();
  @$core.override
  ImportRequest createEmptyInstance() => ImportRequest._();
  @$core.pragma('dart2js:noInline')
  static ImportRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportRequest>(
          ImportRequest.$_createMessage);
  static ImportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get sourcePlatform => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourcePlatform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourcePlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourcePlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get connectedAccountId => $_getSZ(2);
  @$pb.TagNumber(3)
  set connectedAccountId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectedAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectedAccountId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rawData => $_getSZ(3);
  @$pb.TagNumber(4)
  set rawData($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRawData() => $_has(3);
  @$pb.TagNumber(4)
  void clearRawData() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fileName => $_getSZ(4);
  @$pb.TagNumber(5)
  set fileName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileName() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileName() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.String> get columnMappings => $_getMap(5);

  @$pb.TagNumber(7)
  $core.String get defaultCurrency => $_getSZ(6);
  @$pb.TagNumber(7)
  set defaultCurrency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDefaultCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearDefaultCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get previewOnly => $_getBF(7);
  @$pb.TagNumber(8)
  set previewOnly($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPreviewOnly() => $_has(7);
  @$pb.TagNumber(8)
  void clearPreviewOnly() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get previewToken => $_getSZ(8);
  @$pb.TagNumber(9)
  set previewToken($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPreviewToken() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreviewToken() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get dryRun => $_getBF(9);
  @$pb.TagNumber(10)
  set dryRun($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDryRun() => $_has(9);
  @$pb.TagNumber(10)
  void clearDryRun() => $_clearField(10);
}

class ImportResponse extends $pb.GeneratedMessage {
  factory ImportResponse({
    $core.bool? isPreview,
    $core.String? previewToken,
    $core.int? totalRows,
    $core.int? createCount,
    $core.int? updateCount,
    $core.int? unchangedCount,
    $core.int? errorCount,
    $core.bool? requiresMappingCorrection,
    $core.Iterable<$core.String>? mappingErrors,
    $core.Iterable<ImportRowResult>? rows,
    $core.Iterable<Product>? createdProducts,
    $core.String? importFingerprint,
    $core.String? downloadableErrorCsv,
  }) {
    final result = ImportResponse._();
    if (isPreview != null) result.isPreview = isPreview;
    if (previewToken != null) result.previewToken = previewToken;
    if (totalRows != null) result.totalRows = totalRows;
    if (createCount != null) result.createCount = createCount;
    if (updateCount != null) result.updateCount = updateCount;
    if (unchangedCount != null) result.unchangedCount = unchangedCount;
    if (errorCount != null) result.errorCount = errorCount;
    if (requiresMappingCorrection != null)
      result.requiresMappingCorrection = requiresMappingCorrection;
    if (mappingErrors != null) result.mappingErrors.addAll(mappingErrors);
    if (rows != null) result.rows.addAll(rows);
    if (createdProducts != null) result.createdProducts.addAll(createdProducts);
    if (importFingerprint != null) result.importFingerprint = importFingerprint;
    if (downloadableErrorCsv != null)
      result.downloadableErrorCsv = downloadableErrorCsv;
    return result;
  }

  ImportResponse._();

  factory ImportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportResponse()..mergeFromBuffer(data, registry);
  factory ImportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ImportResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isPreview')
    ..aOS(2, _omitFieldNames ? '' : 'previewToken')
    ..aI(3, _omitFieldNames ? '' : 'totalRows')
    ..aI(4, _omitFieldNames ? '' : 'createCount')
    ..aI(5, _omitFieldNames ? '' : 'updateCount')
    ..aI(6, _omitFieldNames ? '' : 'unchangedCount')
    ..aI(7, _omitFieldNames ? '' : 'errorCount')
    ..aOB(8, _omitFieldNames ? '' : 'requiresMappingCorrection')
    ..pPS(9, _omitFieldNames ? '' : 'mappingErrors')
    ..pPM<ImportRowResult>(10, _omitFieldNames ? '' : 'rows',
        subBuilder: ImportRowResult.$_createMessage)
    ..pPM<Product>(11, _omitFieldNames ? '' : 'createdProducts',
        subBuilder: Product.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'importFingerprint')
    ..aOS(13, _omitFieldNames ? '' : 'downloadableErrorCsv')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportResponse copyWith(void Function(ImportResponse) updates) =>
      super.copyWith((message) => updates(message as ImportResponse))
          as ImportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportResponse() / ImportResponse.new instead')
  static ImportResponse create() => ImportResponse._();
  static $pb.GeneratedMessage $_createMessage() => ImportResponse._();
  @$core.override
  ImportResponse createEmptyInstance() => ImportResponse._();
  @$core.pragma('dart2js:noInline')
  static ImportResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportResponse>(
          ImportResponse.$_createMessage);
  static ImportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPreview => $_getBF(0);
  @$pb.TagNumber(1)
  set isPreview($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsPreview() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPreview() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get previewToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set previewToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreviewToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviewToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalRows => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalRows($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalRows() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalRows() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get createCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set createCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreateCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreateCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get updateCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set updateCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdateCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get unchangedCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set unchangedCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnchangedCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnchangedCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get errorCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set errorCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get requiresMappingCorrection => $_getBF(7);
  @$pb.TagNumber(8)
  set requiresMappingCorrection($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRequiresMappingCorrection() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequiresMappingCorrection() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get mappingErrors => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<ImportRowResult> get rows => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<Product> get createdProducts => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get importFingerprint => $_getSZ(11);
  @$pb.TagNumber(12)
  set importFingerprint($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasImportFingerprint() => $_has(11);
  @$pb.TagNumber(12)
  void clearImportFingerprint() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get downloadableErrorCsv => $_getSZ(12);
  @$pb.TagNumber(13)
  set downloadableErrorCsv($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDownloadableErrorCsv() => $_has(12);
  @$pb.TagNumber(13)
  void clearDownloadableErrorCsv() => $_clearField(13);
}

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.String? query,
    $1.Pagination? pagination,
  }) {
    final result = SearchRequest._();
    if (query != null) result.query = query;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchRequest() / SearchRequest.new instead')
  static SearchRequest create() => SearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => SearchRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchRequest>(
          SearchRequest.$_createMessage);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class SearchResponse extends $pb.GeneratedMessage {
  factory SearchResponse({
    $core.Iterable<Product>? products,
    $1.PaginatedResponse? pagination,
  }) {
    final result = SearchResponse._();
    if (products != null) result.products.addAll(products);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchResponse._();

  factory SearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromBuffer(data, registry);
  factory SearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SearchResponse.$_createMessage)
    ..pPM<Product>(1, _omitFieldNames ? '' : 'products',
        subBuilder: Product.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse copyWith(void Function(SearchResponse) updates) =>
      super.copyWith((message) => updates(message as SearchResponse))
          as SearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchResponse() / SearchResponse.new instead')
  static SearchResponse create() => SearchResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchResponse._();
  @$core.override
  SearchResponse createEmptyInstance() => SearchResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchResponse>(
          SearchResponse.$_createMessage);
  static SearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Product> get products => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePagination() => $_ensure(1);
}

class GetStatsRequest extends $pb.GeneratedMessage {
  factory GetStatsRequest({
    $core.String? productId,
  }) {
    final result = GetStatsRequest._();
    if (productId != null) result.productId = productId;
    return result;
  }

  GetStatsRequest._();

  factory GetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsRequest()..mergeFromBuffer(data, registry);
  factory GetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsRequest copyWith(void Function(GetStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatsRequest))
          as GetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatsRequest() / GetStatsRequest.new instead')
  static GetStatsRequest create() => GetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStatsRequest._();
  @$core.override
  GetStatsRequest createEmptyInstance() => GetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStatsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatsRequest>(
          GetStatsRequest.$_createMessage);
  static GetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);
}

class GetStatsResponse extends $pb.GeneratedMessage {
  factory GetStatsResponse({
    $core.String? productId,
    $core.int? totalOrders,
    $1.Money? totalRevenue,
    $core.int? activeSkusCount,
    $core.int? onHandStock,
    $core.int? reservedStock,
  }) {
    final result = GetStatsResponse._();
    if (productId != null) result.productId = productId;
    if (totalOrders != null) result.totalOrders = totalOrders;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (activeSkusCount != null) result.activeSkusCount = activeSkusCount;
    if (onHandStock != null) result.onHandStock = onHandStock;
    if (reservedStock != null) result.reservedStock = reservedStock;
    return result;
  }

  GetStatsResponse._();

  factory GetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsResponse()..mergeFromBuffer(data, registry);
  factory GetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetStatsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aI(2, _omitFieldNames ? '' : 'totalOrders')
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'totalRevenue',
        subBuilder: $1.Money.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'activeSkusCount')
    ..aI(5, _omitFieldNames ? '' : 'onHandStock')
    ..aI(6, _omitFieldNames ? '' : 'reservedStock')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsResponse copyWith(void Function(GetStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatsResponse))
          as GetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatsResponse() / GetStatsResponse.new instead')
  static GetStatsResponse create() => GetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStatsResponse._();
  @$core.override
  GetStatsResponse createEmptyInstance() => GetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStatsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatsResponse>(
          GetStatsResponse.$_createMessage);
  static GetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalOrders => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalOrders($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalOrders() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalOrders() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Money get totalRevenue => $_getN(2);
  @$pb.TagNumber(3)
  set totalRevenue($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalRevenue() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalRevenue() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureTotalRevenue() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get activeSkusCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeSkusCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveSkusCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveSkusCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get onHandStock => $_getIZ(4);
  @$pb.TagNumber(5)
  set onHandStock($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOnHandStock() => $_has(4);
  @$pb.TagNumber(5)
  void clearOnHandStock() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get reservedStock => $_getIZ(5);
  @$pb.TagNumber(6)
  set reservedStock($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReservedStock() => $_has(5);
  @$pb.TagNumber(6)
  void clearReservedStock() => $_clearField(6);
}

class GetSalesStatsRequest extends $pb.GeneratedMessage {
  factory GetSalesStatsRequest({
    $core.String? productId,
    $core.String? period,
  }) {
    final result = GetSalesStatsRequest._();
    if (productId != null) result.productId = productId;
    if (period != null) result.period = period;
    return result;
  }

  GetSalesStatsRequest._();

  factory GetSalesStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesStatsRequest()..mergeFromBuffer(data, registry);
  factory GetSalesStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSalesStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetSalesStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesStatsRequest copyWith(void Function(GetSalesStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSalesStatsRequest))
          as GetSalesStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSalesStatsRequest() / GetSalesStatsRequest.new instead')
  static GetSalesStatsRequest create() => GetSalesStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSalesStatsRequest._();
  @$core.override
  GetSalesStatsRequest createEmptyInstance() => GetSalesStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSalesStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSalesStatsRequest>(
          GetSalesStatsRequest.$_createMessage);
  static GetSalesStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);
}

class GetSalesStatsResponse extends $pb.GeneratedMessage {
  factory GetSalesStatsResponse({
    $core.String? productId,
    $1.Money? grossSales,
    $1.Money? netSales,
    $core.int? unitsSold,
    $core.int? refundCount,
  }) {
    final result = GetSalesStatsResponse._();
    if (productId != null) result.productId = productId;
    if (grossSales != null) result.grossSales = grossSales;
    if (netSales != null) result.netSales = netSales;
    if (unitsSold != null) result.unitsSold = unitsSold;
    if (refundCount != null) result.refundCount = refundCount;
    return result;
  }

  GetSalesStatsResponse._();

  factory GetSalesStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesStatsResponse()..mergeFromBuffer(data, registry);
  factory GetSalesStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSalesStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetSalesStatsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'grossSales',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'netSales',
        subBuilder: $1.Money.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'unitsSold')
    ..aI(5, _omitFieldNames ? '' : 'refundCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesStatsResponse copyWith(
          void Function(GetSalesStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSalesStatsResponse))
          as GetSalesStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSalesStatsResponse() / GetSalesStatsResponse.new instead')
  static GetSalesStatsResponse create() => GetSalesStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSalesStatsResponse._();
  @$core.override
  GetSalesStatsResponse createEmptyInstance() => GetSalesStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSalesStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSalesStatsResponse>(
          GetSalesStatsResponse.$_createMessage);
  static GetSalesStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Money get grossSales => $_getN(1);
  @$pb.TagNumber(2)
  set grossSales($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGrossSales() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrossSales() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensureGrossSales() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Money get netSales => $_getN(2);
  @$pb.TagNumber(3)
  set netSales($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNetSales() => $_has(2);
  @$pb.TagNumber(3)
  void clearNetSales() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureNetSales() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get unitsSold => $_getIZ(3);
  @$pb.TagNumber(4)
  set unitsSold($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitsSold() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitsSold() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get refundCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set refundCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefundCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefundCount() => $_clearField(5);
}

class SalesChartPoint extends $pb.GeneratedMessage {
  factory SalesChartPoint({
    $core.String? timestamp,
    $1.Money? amount,
    $core.int? orderCount,
  }) {
    final result = SalesChartPoint._();
    if (timestamp != null) result.timestamp = timestamp;
    if (amount != null) result.amount = amount;
    if (orderCount != null) result.orderCount = orderCount;
    return result;
  }

  SalesChartPoint._();

  factory SalesChartPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SalesChartPoint()..mergeFromBuffer(data, registry);
  factory SalesChartPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SalesChartPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SalesChartPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SalesChartPoint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'timestamp')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'orderCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SalesChartPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SalesChartPoint copyWith(void Function(SalesChartPoint) updates) =>
      super.copyWith((message) => updates(message as SalesChartPoint))
          as SalesChartPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SalesChartPoint() / SalesChartPoint.new instead')
  static SalesChartPoint create() => SalesChartPoint._();
  static $pb.GeneratedMessage $_createMessage() => SalesChartPoint._();
  @$core.override
  SalesChartPoint createEmptyInstance() => SalesChartPoint._();
  @$core.pragma('dart2js:noInline')
  static SalesChartPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SalesChartPoint>(
          SalesChartPoint.$_createMessage);
  static SalesChartPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get timestamp => $_getSZ(0);
  @$pb.TagNumber(1)
  set timestamp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Money get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get orderCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set orderCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderCount() => $_clearField(3);
}

class GetSalesChartRequest extends $pb.GeneratedMessage {
  factory GetSalesChartRequest({
    $core.String? productId,
    $core.String? interval,
  }) {
    final result = GetSalesChartRequest._();
    if (productId != null) result.productId = productId;
    if (interval != null) result.interval = interval;
    return result;
  }

  GetSalesChartRequest._();

  factory GetSalesChartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesChartRequest()..mergeFromBuffer(data, registry);
  factory GetSalesChartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesChartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSalesChartRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetSalesChartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'interval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesChartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesChartRequest copyWith(void Function(GetSalesChartRequest) updates) =>
      super.copyWith((message) => updates(message as GetSalesChartRequest))
          as GetSalesChartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSalesChartRequest() / GetSalesChartRequest.new instead')
  static GetSalesChartRequest create() => GetSalesChartRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSalesChartRequest._();
  @$core.override
  GetSalesChartRequest createEmptyInstance() => GetSalesChartRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSalesChartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSalesChartRequest>(
          GetSalesChartRequest.$_createMessage);
  static GetSalesChartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get interval => $_getSZ(1);
  @$pb.TagNumber(2)
  set interval($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInterval() => $_has(1);
  @$pb.TagNumber(2)
  void clearInterval() => $_clearField(2);
}

class GetSalesChartResponse extends $pb.GeneratedMessage {
  factory GetSalesChartResponse({
    $core.String? productId,
    $core.Iterable<SalesChartPoint>? dataPoints,
  }) {
    final result = GetSalesChartResponse._();
    if (productId != null) result.productId = productId;
    if (dataPoints != null) result.dataPoints.addAll(dataPoints);
    return result;
  }

  GetSalesChartResponse._();

  factory GetSalesChartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesChartResponse()..mergeFromBuffer(data, registry);
  factory GetSalesChartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSalesChartResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSalesChartResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetSalesChartResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..pPM<SalesChartPoint>(2, _omitFieldNames ? '' : 'dataPoints',
        subBuilder: SalesChartPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesChartResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSalesChartResponse copyWith(
          void Function(GetSalesChartResponse) updates) =>
      super.copyWith((message) => updates(message as GetSalesChartResponse))
          as GetSalesChartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSalesChartResponse() / GetSalesChartResponse.new instead')
  static GetSalesChartResponse create() => GetSalesChartResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSalesChartResponse._();
  @$core.override
  GetSalesChartResponse createEmptyInstance() => GetSalesChartResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSalesChartResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSalesChartResponse>(
          GetSalesChartResponse.$_createMessage);
  static GetSalesChartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SalesChartPoint> get dataPoints => $_getList(1);
}

class ProductReviewItem extends $pb.GeneratedMessage {
  factory ProductReviewItem({
    $core.String? reviewId,
    $core.String? authorName,
    $core.int? rating,
    $core.String? comment,
    $2.Timestamp? createdAt,
  }) {
    final result = ProductReviewItem._();
    if (reviewId != null) result.reviewId = reviewId;
    if (authorName != null) result.authorName = authorName;
    if (rating != null) result.rating = rating;
    if (comment != null) result.comment = comment;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ProductReviewItem._();

  factory ProductReviewItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductReviewItem()..mergeFromBuffer(data, registry);
  factory ProductReviewItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductReviewItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductReviewItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ProductReviewItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'authorName')
    ..aI(3, _omitFieldNames ? '' : 'rating')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductReviewItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductReviewItem copyWith(void Function(ProductReviewItem) updates) =>
      super.copyWith((message) => updates(message as ProductReviewItem))
          as ProductReviewItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProductReviewItem() / ProductReviewItem.new instead')
  static ProductReviewItem create() => ProductReviewItem._();
  static $pb.GeneratedMessage $_createMessage() => ProductReviewItem._();
  @$core.override
  ProductReviewItem createEmptyInstance() => ProductReviewItem._();
  @$core.pragma('dart2js:noInline')
  static ProductReviewItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProductReviewItem>(
          ProductReviewItem.$_createMessage);
  static ProductReviewItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get authorName => $_getSZ(1);
  @$pb.TagNumber(2)
  set authorName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorName() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureCreatedAt() => $_ensure(4);
}

class GetReviewsRequest extends $pb.GeneratedMessage {
  factory GetReviewsRequest({
    $core.String? productId,
    $1.Pagination? pagination,
  }) {
    final result = GetReviewsRequest._();
    if (productId != null) result.productId = productId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetReviewsRequest._();

  factory GetReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewsRequest()..mergeFromBuffer(data, registry);
  factory GetReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReviewsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetReviewsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewsRequest copyWith(void Function(GetReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as GetReviewsRequest))
          as GetReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetReviewsRequest() / GetReviewsRequest.new instead')
  static GetReviewsRequest create() => GetReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReviewsRequest._();
  @$core.override
  GetReviewsRequest createEmptyInstance() => GetReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReviewsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReviewsRequest>(
          GetReviewsRequest.$_createMessage);
  static GetReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class GetReviewsResponse extends $pb.GeneratedMessage {
  factory GetReviewsResponse({
    $core.String? productId,
    $core.Iterable<ProductReviewItem>? reviews,
    $1.PaginatedResponse? pagination,
  }) {
    final result = GetReviewsResponse._();
    if (productId != null) result.productId = productId;
    if (reviews != null) result.reviews.addAll(reviews);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetReviewsResponse._();

  factory GetReviewsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewsResponse()..mergeFromBuffer(data, registry);
  factory GetReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReviewsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReviewsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetReviewsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..pPM<ProductReviewItem>(2, _omitFieldNames ? '' : 'reviews',
        subBuilder: ProductReviewItem.$_createMessage)
    ..aOM<$1.PaginatedResponse>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReviewsResponse copyWith(void Function(GetReviewsResponse) updates) =>
      super.copyWith((message) => updates(message as GetReviewsResponse))
          as GetReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetReviewsResponse() / GetReviewsResponse.new instead')
  static GetReviewsResponse create() => GetReviewsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetReviewsResponse._();
  @$core.override
  GetReviewsResponse createEmptyInstance() => GetReviewsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReviewsResponse>(
          GetReviewsResponse.$_createMessage);
  static GetReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ProductReviewItem> get reviews => $_getList(1);

  @$pb.TagNumber(3)
  $1.PaginatedResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginatedResponse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PaginatedResponse ensurePagination() => $_ensure(2);
}

class GetRankRequest extends $pb.GeneratedMessage {
  factory GetRankRequest({
    $core.String? productId,
    $core.String? category,
  }) {
    final result = GetRankRequest._();
    if (productId != null) result.productId = productId;
    if (category != null) result.category = category;
    return result;
  }

  GetRankRequest._();

  factory GetRankRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRankRequest()..mergeFromBuffer(data, registry);
  factory GetRankRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRankRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRankRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRankRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRankRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRankRequest copyWith(void Function(GetRankRequest) updates) =>
      super.copyWith((message) => updates(message as GetRankRequest))
          as GetRankRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetRankRequest() / GetRankRequest.new instead')
  static GetRankRequest create() => GetRankRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRankRequest._();
  @$core.override
  GetRankRequest createEmptyInstance() => GetRankRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRankRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRankRequest>(
          GetRankRequest.$_createMessage);
  static GetRankRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);
}

class GetRankResponse extends $pb.GeneratedMessage {
  factory GetRankResponse({
    $core.String? productId,
    $core.int? rankInCategory,
    $core.int? rankInWorkspace,
  }) {
    final result = GetRankResponse._();
    if (productId != null) result.productId = productId;
    if (rankInCategory != null) result.rankInCategory = rankInCategory;
    if (rankInWorkspace != null) result.rankInWorkspace = rankInWorkspace;
    return result;
  }

  GetRankResponse._();

  factory GetRankResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRankResponse()..mergeFromBuffer(data, registry);
  factory GetRankResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRankResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRankResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRankResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aI(2, _omitFieldNames ? '' : 'rankInCategory')
    ..aI(3, _omitFieldNames ? '' : 'rankInWorkspace')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRankResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRankResponse copyWith(void Function(GetRankResponse) updates) =>
      super.copyWith((message) => updates(message as GetRankResponse))
          as GetRankResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetRankResponse() / GetRankResponse.new instead')
  static GetRankResponse create() => GetRankResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetRankResponse._();
  @$core.override
  GetRankResponse createEmptyInstance() => GetRankResponse._();
  @$core.pragma('dart2js:noInline')
  static GetRankResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRankResponse>(
          GetRankResponse.$_createMessage);
  static GetRankResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rankInCategory => $_getIZ(1);
  @$pb.TagNumber(2)
  set rankInCategory($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRankInCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearRankInCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rankInWorkspace => $_getIZ(2);
  @$pb.TagNumber(3)
  set rankInWorkspace($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRankInWorkspace() => $_has(2);
  @$pb.TagNumber(3)
  void clearRankInWorkspace() => $_clearField(3);
}

class GetLinkedContentRequest extends $pb.GeneratedMessage {
  factory GetLinkedContentRequest({
    $core.String? productId,
  }) {
    final result = GetLinkedContentRequest._();
    if (productId != null) result.productId = productId;
    return result;
  }

  GetLinkedContentRequest._();

  factory GetLinkedContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLinkedContentRequest()..mergeFromBuffer(data, registry);
  factory GetLinkedContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLinkedContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinkedContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetLinkedContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedContentRequest copyWith(
          void Function(GetLinkedContentRequest) updates) =>
      super.copyWith((message) => updates(message as GetLinkedContentRequest))
          as GetLinkedContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetLinkedContentRequest() / GetLinkedContentRequest.new instead')
  static GetLinkedContentRequest create() => GetLinkedContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetLinkedContentRequest._();
  @$core.override
  GetLinkedContentRequest createEmptyInstance() => GetLinkedContentRequest._();
  @$core.pragma('dart2js:noInline')
  static GetLinkedContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinkedContentRequest>(
          GetLinkedContentRequest.$_createMessage);
  static GetLinkedContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);
}

class GetLinkedContentResponse extends $pb.GeneratedMessage {
  factory GetLinkedContentResponse({
    $core.String? productId,
    $core.Iterable<ContentRef>? linkedContents,
  }) {
    final result = GetLinkedContentResponse._();
    if (productId != null) result.productId = productId;
    if (linkedContents != null) result.linkedContents.addAll(linkedContents);
    return result;
  }

  GetLinkedContentResponse._();

  factory GetLinkedContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLinkedContentResponse()..mergeFromBuffer(data, registry);
  factory GetLinkedContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLinkedContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinkedContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetLinkedContentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..pPM<ContentRef>(2, _omitFieldNames ? '' : 'linkedContents',
        subBuilder: ContentRef.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedContentResponse copyWith(
          void Function(GetLinkedContentResponse) updates) =>
      super.copyWith((message) => updates(message as GetLinkedContentResponse))
          as GetLinkedContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetLinkedContentResponse() / GetLinkedContentResponse.new instead')
  static GetLinkedContentResponse create() => GetLinkedContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetLinkedContentResponse._();
  @$core.override
  GetLinkedContentResponse createEmptyInstance() =>
      GetLinkedContentResponse._();
  @$core.pragma('dart2js:noInline')
  static GetLinkedContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinkedContentResponse>(
          GetLinkedContentResponse.$_createMessage);
  static GetLinkedContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ContentRef> get linkedContents => $_getList(1);
}

class LinkContentRequest extends $pb.GeneratedMessage {
  factory LinkContentRequest({
    $1.CommandContext? context,
    $core.String? productId,
    $core.String? contentId,
    $core.String? contentType,
    $core.String? title,
    $core.String? url,
    $core.String? metadataJson,
  }) {
    final result = LinkContentRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    if (contentId != null) result.contentId = contentId;
    if (contentType != null) result.contentType = contentType;
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    if (metadataJson != null) result.metadataJson = metadataJson;
    return result;
  }

  LinkContentRequest._();

  factory LinkContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkContentRequest()..mergeFromBuffer(data, registry);
  factory LinkContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkContentRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'contentId')
    ..aOS(4, _omitFieldNames ? '' : 'contentType')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'url')
    ..aOS(7, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkContentRequest copyWith(void Function(LinkContentRequest) updates) =>
      super.copyWith((message) => updates(message as LinkContentRequest))
          as LinkContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkContentRequest() / LinkContentRequest.new instead')
  static LinkContentRequest create() => LinkContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => LinkContentRequest._();
  @$core.override
  LinkContentRequest createEmptyInstance() => LinkContentRequest._();
  @$core.pragma('dart2js:noInline')
  static LinkContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkContentRequest>(
          LinkContentRequest.$_createMessage);
  static LinkContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get url => $_getSZ(5);
  @$pb.TagNumber(6)
  set url($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get metadataJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set metadataJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMetadataJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadataJson() => $_clearField(7);
}

class LinkContentResponse extends $pb.GeneratedMessage {
  factory LinkContentResponse({
    $core.bool? success,
    ContentRef? linkedContent,
  }) {
    final result = LinkContentResponse._();
    if (success != null) result.success = success;
    if (linkedContent != null) result.linkedContent = linkedContent;
    return result;
  }

  LinkContentResponse._();

  factory LinkContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkContentResponse()..mergeFromBuffer(data, registry);
  factory LinkContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkContentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<ContentRef>(2, _omitFieldNames ? '' : 'linkedContent',
        subBuilder: ContentRef.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkContentResponse copyWith(void Function(LinkContentResponse) updates) =>
      super.copyWith((message) => updates(message as LinkContentResponse))
          as LinkContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use LinkContentResponse() / LinkContentResponse.new instead')
  static LinkContentResponse create() => LinkContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => LinkContentResponse._();
  @$core.override
  LinkContentResponse createEmptyInstance() => LinkContentResponse._();
  @$core.pragma('dart2js:noInline')
  static LinkContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkContentResponse>(
          LinkContentResponse.$_createMessage);
  static LinkContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  ContentRef get linkedContent => $_getN(1);
  @$pb.TagNumber(2)
  set linkedContent(ContentRef value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLinkedContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearLinkedContent() => $_clearField(2);
  @$pb.TagNumber(2)
  ContentRef ensureLinkedContent() => $_ensure(1);
}

class UpdateStockRequest extends $pb.GeneratedMessage {
  factory UpdateStockRequest({
    $1.CommandContext? context,
    $core.String? productId,
    $core.String? skuId,
    $core.int? deltaQuantity,
    $core.String? reason,
  }) {
    final result = UpdateStockRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    if (skuId != null) result.skuId = skuId;
    if (deltaQuantity != null) result.deltaQuantity = deltaQuantity;
    if (reason != null) result.reason = reason;
    return result;
  }

  UpdateStockRequest._();

  factory UpdateStockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateStockRequest()..mergeFromBuffer(data, registry);
  factory UpdateStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateStockRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateStockRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'skuId')
    ..aI(4, _omitFieldNames ? '' : 'deltaQuantity')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStockRequest copyWith(void Function(UpdateStockRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateStockRequest))
          as UpdateStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateStockRequest() / UpdateStockRequest.new instead')
  static UpdateStockRequest create() => UpdateStockRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateStockRequest._();
  @$core.override
  UpdateStockRequest createEmptyInstance() => UpdateStockRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateStockRequest>(
          UpdateStockRequest.$_createMessage);
  static UpdateStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get skuId => $_getSZ(2);
  @$pb.TagNumber(3)
  set skuId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkuId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkuId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get deltaQuantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set deltaQuantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeltaQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeltaQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class UpdateStockResponse extends $pb.GeneratedMessage {
  factory UpdateStockResponse({
    $core.String? skuId,
    $core.int? newStockQuantity,
  }) {
    final result = UpdateStockResponse._();
    if (skuId != null) result.skuId = skuId;
    if (newStockQuantity != null) result.newStockQuantity = newStockQuantity;
    return result;
  }

  UpdateStockResponse._();

  factory UpdateStockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateStockResponse()..mergeFromBuffer(data, registry);
  factory UpdateStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateStockResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateStockResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aI(2, _omitFieldNames ? '' : 'newStockQuantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStockResponse copyWith(void Function(UpdateStockResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateStockResponse))
          as UpdateStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateStockResponse() / UpdateStockResponse.new instead')
  static UpdateStockResponse create() => UpdateStockResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateStockResponse._();
  @$core.override
  UpdateStockResponse createEmptyInstance() => UpdateStockResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateStockResponse>(
          UpdateStockResponse.$_createMessage);
  static UpdateStockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get newStockQuantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set newStockQuantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewStockQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewStockQuantity() => $_clearField(2);
}

class SetAlertThresholdRequest extends $pb.GeneratedMessage {
  factory SetAlertThresholdRequest({
    $1.CommandContext? context,
    $core.String? productId,
    $core.String? skuId,
    $core.int? lowStockThreshold,
  }) {
    final result = SetAlertThresholdRequest._();
    if (context != null) result.context = context;
    if (productId != null) result.productId = productId;
    if (skuId != null) result.skuId = skuId;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    return result;
  }

  SetAlertThresholdRequest._();

  factory SetAlertThresholdRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertThresholdRequest()..mergeFromBuffer(data, registry);
  factory SetAlertThresholdRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertThresholdRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlertThresholdRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SetAlertThresholdRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'skuId')
    ..aI(4, _omitFieldNames ? '' : 'lowStockThreshold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertThresholdRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertThresholdRequest copyWith(
          void Function(SetAlertThresholdRequest) updates) =>
      super.copyWith((message) => updates(message as SetAlertThresholdRequest))
          as SetAlertThresholdRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetAlertThresholdRequest() / SetAlertThresholdRequest.new instead')
  static SetAlertThresholdRequest create() => SetAlertThresholdRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetAlertThresholdRequest._();
  @$core.override
  SetAlertThresholdRequest createEmptyInstance() =>
      SetAlertThresholdRequest._();
  @$core.pragma('dart2js:noInline')
  static SetAlertThresholdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlertThresholdRequest>(
          SetAlertThresholdRequest.$_createMessage);
  static SetAlertThresholdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get skuId => $_getSZ(2);
  @$pb.TagNumber(3)
  set skuId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkuId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkuId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get lowStockThreshold => $_getIZ(3);
  @$pb.TagNumber(4)
  set lowStockThreshold($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLowStockThreshold() => $_has(3);
  @$pb.TagNumber(4)
  void clearLowStockThreshold() => $_clearField(4);
}

class SetAlertThresholdResponse extends $pb.GeneratedMessage {
  factory SetAlertThresholdResponse({
    $core.String? skuId,
    $core.int? lowStockThreshold,
  }) {
    final result = SetAlertThresholdResponse._();
    if (skuId != null) result.skuId = skuId;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    return result;
  }

  SetAlertThresholdResponse._();

  factory SetAlertThresholdResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertThresholdResponse()..mergeFromBuffer(data, registry);
  factory SetAlertThresholdResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertThresholdResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlertThresholdResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SetAlertThresholdResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aI(2, _omitFieldNames ? '' : 'lowStockThreshold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertThresholdResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertThresholdResponse copyWith(
          void Function(SetAlertThresholdResponse) updates) =>
      super.copyWith((message) => updates(message as SetAlertThresholdResponse))
          as SetAlertThresholdResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetAlertThresholdResponse() / SetAlertThresholdResponse.new instead')
  static SetAlertThresholdResponse create() => SetAlertThresholdResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetAlertThresholdResponse._();
  @$core.override
  SetAlertThresholdResponse createEmptyInstance() =>
      SetAlertThresholdResponse._();
  @$core.pragma('dart2js:noInline')
  static SetAlertThresholdResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlertThresholdResponse>(
          SetAlertThresholdResponse.$_createMessage);
  static SetAlertThresholdResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get lowStockThreshold => $_getIZ(1);
  @$pb.TagNumber(2)
  set lowStockThreshold($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLowStockThreshold() => $_has(1);
  @$pb.TagNumber(2)
  void clearLowStockThreshold() => $_clearField(2);
}

class BulkArchiveRequest extends $pb.GeneratedMessage {
  factory BulkArchiveRequest({
    $1.CommandContext? context,
    $core.Iterable<$core.String>? productIds,
  }) {
    final result = BulkArchiveRequest._();
    if (context != null) result.context = context;
    if (productIds != null) result.productIds.addAll(productIds);
    return result;
  }

  BulkArchiveRequest._();

  factory BulkArchiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkArchiveRequest()..mergeFromBuffer(data, registry);
  factory BulkArchiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkArchiveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BulkArchiveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BulkArchiveRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'productIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkArchiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkArchiveRequest copyWith(void Function(BulkArchiveRequest) updates) =>
      super.copyWith((message) => updates(message as BulkArchiveRequest))
          as BulkArchiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BulkArchiveRequest() / BulkArchiveRequest.new instead')
  static BulkArchiveRequest create() => BulkArchiveRequest._();
  static $pb.GeneratedMessage $_createMessage() => BulkArchiveRequest._();
  @$core.override
  BulkArchiveRequest createEmptyInstance() => BulkArchiveRequest._();
  @$core.pragma('dart2js:noInline')
  static BulkArchiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BulkArchiveRequest>(
          BulkArchiveRequest.$_createMessage);
  static BulkArchiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get productIds => $_getList(1);
}

class BulkArchiveResponse extends $pb.GeneratedMessage {
  factory BulkArchiveResponse({
    $core.int? archivedCount,
  }) {
    final result = BulkArchiveResponse._();
    if (archivedCount != null) result.archivedCount = archivedCount;
    return result;
  }

  BulkArchiveResponse._();

  factory BulkArchiveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkArchiveResponse()..mergeFromBuffer(data, registry);
  factory BulkArchiveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BulkArchiveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BulkArchiveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BulkArchiveResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'archivedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkArchiveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BulkArchiveResponse copyWith(void Function(BulkArchiveResponse) updates) =>
      super.copyWith((message) => updates(message as BulkArchiveResponse))
          as BulkArchiveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BulkArchiveResponse() / BulkArchiveResponse.new instead')
  static BulkArchiveResponse create() => BulkArchiveResponse._();
  static $pb.GeneratedMessage $_createMessage() => BulkArchiveResponse._();
  @$core.override
  BulkArchiveResponse createEmptyInstance() => BulkArchiveResponse._();
  @$core.pragma('dart2js:noInline')
  static BulkArchiveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BulkArchiveResponse>(
          BulkArchiveResponse.$_createMessage);
  static BulkArchiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get archivedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set archivedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasArchivedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearArchivedCount() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
