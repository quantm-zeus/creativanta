// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/order.proto.

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
import 'order.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'order.pbenum.dart';

/// Single item line in an order per DB Schema §25.1.
class OrderItem extends $pb.GeneratedMessage {
  factory OrderItem({
    $core.String? sku,
    $core.String? productId,
    $core.String? name,
    $core.int? quantity,
    $1.Money? unitPrice,
    $1.Money? discount,
    $1.Money? total,
    $1.Money? unitCogs,
    OrderSourceClass? cogsSourceClass,
    $core.String? variation,
    $core.String? platformItemId,
  }) {
    final result = OrderItem._();
    if (sku != null) result.sku = sku;
    if (productId != null) result.productId = productId;
    if (name != null) result.name = name;
    if (quantity != null) result.quantity = quantity;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (discount != null) result.discount = discount;
    if (total != null) result.total = total;
    if (unitCogs != null) result.unitCogs = unitCogs;
    if (cogsSourceClass != null) result.cogsSourceClass = cogsSourceClass;
    if (variation != null) result.variation = variation;
    if (platformItemId != null) result.platformItemId = platformItemId;
    return result;
  }

  OrderItem._();

  factory OrderItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderItem()..mergeFromBuffer(data, registry);
  factory OrderItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sku')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'discount',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'total',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(8, _omitFieldNames ? '' : 'unitCogs',
        subBuilder: $1.Money.$_createMessage)
    ..aE<OrderSourceClass>(9, _omitFieldNames ? '' : 'cogsSourceClass',
        enumValues: OrderSourceClass.values)
    ..aOS(10, _omitFieldNames ? '' : 'variation')
    ..aOS(11, _omitFieldNames ? '' : 'platformItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderItem copyWith(void Function(OrderItem) updates) =>
      super.copyWith((message) => updates(message as OrderItem)) as OrderItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderItem() / OrderItem.new instead')
  static OrderItem create() => OrderItem._();
  static $pb.GeneratedMessage $_createMessage() => OrderItem._();
  @$core.override
  OrderItem createEmptyInstance() => OrderItem._();
  @$core.pragma('dart2js:noInline')
  static OrderItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderItem>(OrderItem.$_createMessage);
  static OrderItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sku => $_getSZ(0);
  @$pb.TagNumber(1)
  set sku($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSku() => $_has(0);
  @$pb.TagNumber(1)
  void clearSku() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get unitPrice => $_getN(4);
  @$pb.TagNumber(5)
  set unitPrice($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitPrice() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureUnitPrice() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Money get discount => $_getN(5);
  @$pb.TagNumber(6)
  set discount($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscount() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscount() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureDiscount() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get total => $_getN(6);
  @$pb.TagNumber(7)
  set total($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTotal() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotal() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureTotal() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Money get unitCogs => $_getN(7);
  @$pb.TagNumber(8)
  set unitCogs($1.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUnitCogs() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnitCogs() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Money ensureUnitCogs() => $_ensure(7);

  @$pb.TagNumber(9)
  OrderSourceClass get cogsSourceClass => $_getN(8);
  @$pb.TagNumber(9)
  set cogsSourceClass(OrderSourceClass value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCogsSourceClass() => $_has(8);
  @$pb.TagNumber(9)
  void clearCogsSourceClass() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get variation => $_getSZ(9);
  @$pb.TagNumber(10)
  set variation($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVariation() => $_has(9);
  @$pb.TagNumber(10)
  void clearVariation() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get platformItemId => $_getSZ(10);
  @$pb.TagNumber(11)
  set platformItemId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPlatformItemId() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlatformItemId() => $_clearField(11);
}

/// Other fee component in fee breakdown.
class OtherFee extends $pb.GeneratedMessage {
  factory OtherFee({
    $core.String? name,
    $1.Money? amount,
  }) {
    final result = OtherFee._();
    if (name != null) result.name = name;
    if (amount != null) result.amount = amount;
    return result;
  }

  OtherFee._();

  factory OtherFee.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OtherFee()..mergeFromBuffer(data, registry);
  factory OtherFee.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OtherFee()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OtherFee',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OtherFee.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OtherFee clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OtherFee copyWith(void Function(OtherFee) updates) =>
      super.copyWith((message) => updates(message as OtherFee)) as OtherFee;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OtherFee() / OtherFee.new instead')
  static OtherFee create() => OtherFee._();
  static $pb.GeneratedMessage $_createMessage() => OtherFee._();
  @$core.override
  OtherFee createEmptyInstance() => OtherFee._();
  @$core.pragma('dart2js:noInline')
  static OtherFee getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OtherFee>(OtherFee.$_createMessage);
  static OtherFee? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

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
}

/// Order fee decomposition per DB Schema §25.1.
class FeeBreakdown extends $pb.GeneratedMessage {
  factory FeeBreakdown({
    $1.Money? platformFee,
    $1.Money? paymentProcessingFee,
    $1.Money? shippingFee,
    $1.Money? tax,
    $1.Money? commission,
    $1.Money? promoDiscount,
    $core.Iterable<OtherFee>? otherFees,
    $1.Money? totalFees,
    $core.String? currency,
  }) {
    final result = FeeBreakdown._();
    if (platformFee != null) result.platformFee = platformFee;
    if (paymentProcessingFee != null)
      result.paymentProcessingFee = paymentProcessingFee;
    if (shippingFee != null) result.shippingFee = shippingFee;
    if (tax != null) result.tax = tax;
    if (commission != null) result.commission = commission;
    if (promoDiscount != null) result.promoDiscount = promoDiscount;
    if (otherFees != null) result.otherFees.addAll(otherFees);
    if (totalFees != null) result.totalFees = totalFees;
    if (currency != null) result.currency = currency;
    return result;
  }

  FeeBreakdown._();

  factory FeeBreakdown.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeeBreakdown()..mergeFromBuffer(data, registry);
  factory FeeBreakdown.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeeBreakdown()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeeBreakdown',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: FeeBreakdown.$_createMessage)
    ..aOM<$1.Money>(1, _omitFieldNames ? '' : 'platformFee',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'paymentProcessingFee',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'shippingFee',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(4, _omitFieldNames ? '' : 'tax',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'commission',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'promoDiscount',
        subBuilder: $1.Money.$_createMessage)
    ..pPM<OtherFee>(7, _omitFieldNames ? '' : 'otherFees',
        subBuilder: OtherFee.$_createMessage)
    ..aOM<$1.Money>(8, _omitFieldNames ? '' : 'totalFees',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeeBreakdown clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeeBreakdown copyWith(void Function(FeeBreakdown) updates) =>
      super.copyWith((message) => updates(message as FeeBreakdown))
          as FeeBreakdown;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeeBreakdown() / FeeBreakdown.new instead')
  static FeeBreakdown create() => FeeBreakdown._();
  static $pb.GeneratedMessage $_createMessage() => FeeBreakdown._();
  @$core.override
  FeeBreakdown createEmptyInstance() => FeeBreakdown._();
  @$core.pragma('dart2js:noInline')
  static FeeBreakdown getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeeBreakdown>(
          FeeBreakdown.$_createMessage);
  static FeeBreakdown? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Money get platformFee => $_getN(0);
  @$pb.TagNumber(1)
  set platformFee($1.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatformFee() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatformFee() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Money ensurePlatformFee() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Money get paymentProcessingFee => $_getN(1);
  @$pb.TagNumber(2)
  set paymentProcessingFee($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentProcessingFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentProcessingFee() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensurePaymentProcessingFee() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Money get shippingFee => $_getN(2);
  @$pb.TagNumber(3)
  set shippingFee($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShippingFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearShippingFee() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureShippingFee() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Money get tax => $_getN(3);
  @$pb.TagNumber(4)
  set tax($1.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTax() => $_has(3);
  @$pb.TagNumber(4)
  void clearTax() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Money ensureTax() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Money get commission => $_getN(4);
  @$pb.TagNumber(5)
  set commission($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCommission() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommission() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureCommission() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Money get promoDiscount => $_getN(5);
  @$pb.TagNumber(6)
  set promoDiscount($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPromoDiscount() => $_has(5);
  @$pb.TagNumber(6)
  void clearPromoDiscount() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensurePromoDiscount() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<OtherFee> get otherFees => $_getList(6);

  @$pb.TagNumber(8)
  $1.Money get totalFees => $_getN(7);
  @$pb.TagNumber(8)
  set totalFees($1.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalFees() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalFees() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Money ensureTotalFees() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get currency => $_getSZ(8);
  @$pb.TagNumber(9)
  set currency($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrency() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrency() => $_clearField(9);
}

/// Canonical Order object per DB Schema §10.3.
class Order extends $pb.GeneratedMessage {
  factory Order({
    $core.String? orderId,
    $core.String? workspaceId,
    OrderSourceClass? sourceClass,
    $core.String? sourcePlatform,
    $core.String? externalOrderId,
    $core.String? connectedAccountId,
    $1.Money? taxAmount,
    $core.String? taxJurisdiction,
    $core.String? taxNote,
    $core.String? exchangeRateSnapshotJson,
    $2.Timestamp? recognizedAt,
    $2.Timestamp? sourceUpdatedAt,
    $core.String? importFingerprint,
    OrderLifecycleState? lifecycleState,
    $1.Money? amount,
    $core.String? currency,
    $core.String? productId,
    $core.String? offerId,
    $core.String? campaignId,
    $core.String? postId,
    $core.String? liveSessionId,
    $core.String? customerEntityId,
    $core.Iterable<OrderItem>? items,
    FeeBreakdown? feeBreakdown,
    $core.String? shippingAddressJson,
    $core.String? reconciliationState,
    $core.Iterable<$core.String>? evidenceRefs,
    $core.String? metadataJson,
    $2.Timestamp? orderedAt,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $2.Timestamp? deletedAt,
  }) {
    final result = Order._();
    if (orderId != null) result.orderId = orderId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (externalOrderId != null) result.externalOrderId = externalOrderId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (taxAmount != null) result.taxAmount = taxAmount;
    if (taxJurisdiction != null) result.taxJurisdiction = taxJurisdiction;
    if (taxNote != null) result.taxNote = taxNote;
    if (exchangeRateSnapshotJson != null)
      result.exchangeRateSnapshotJson = exchangeRateSnapshotJson;
    if (recognizedAt != null) result.recognizedAt = recognizedAt;
    if (sourceUpdatedAt != null) result.sourceUpdatedAt = sourceUpdatedAt;
    if (importFingerprint != null) result.importFingerprint = importFingerprint;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (campaignId != null) result.campaignId = campaignId;
    if (postId != null) result.postId = postId;
    if (liveSessionId != null) result.liveSessionId = liveSessionId;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (items != null) result.items.addAll(items);
    if (feeBreakdown != null) result.feeBreakdown = feeBreakdown;
    if (shippingAddressJson != null)
      result.shippingAddressJson = shippingAddressJson;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (evidenceRefs != null) result.evidenceRefs.addAll(evidenceRefs);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (orderedAt != null) result.orderedAt = orderedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  Order._();

  factory Order.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Order()..mergeFromBuffer(data, registry);
  factory Order.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Order()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Order',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Order.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<OrderSourceClass>(3, _omitFieldNames ? '' : 'sourceClass',
        enumValues: OrderSourceClass.values)
    ..aOS(4, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(5, _omitFieldNames ? '' : 'externalOrderId')
    ..aOS(6, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'taxAmount',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'taxJurisdiction')
    ..aOS(9, _omitFieldNames ? '' : 'taxNote')
    ..aOS(10, _omitFieldNames ? '' : 'exchangeRateSnapshotJson')
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'recognizedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'sourceUpdatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(13, _omitFieldNames ? '' : 'importFingerprint')
    ..aE<OrderLifecycleState>(14, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: OrderLifecycleState.values)
    ..aOM<$1.Money>(15, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(16, _omitFieldNames ? '' : 'currency')
    ..aOS(17, _omitFieldNames ? '' : 'productId')
    ..aOS(18, _omitFieldNames ? '' : 'offerId')
    ..aOS(19, _omitFieldNames ? '' : 'campaignId')
    ..aOS(20, _omitFieldNames ? '' : 'postId')
    ..aOS(21, _omitFieldNames ? '' : 'liveSessionId')
    ..aOS(22, _omitFieldNames ? '' : 'customerEntityId')
    ..pPM<OrderItem>(23, _omitFieldNames ? '' : 'items',
        subBuilder: OrderItem.$_createMessage)
    ..aOM<FeeBreakdown>(24, _omitFieldNames ? '' : 'feeBreakdown',
        subBuilder: FeeBreakdown.$_createMessage)
    ..aOS(25, _omitFieldNames ? '' : 'shippingAddressJson')
    ..aOS(26, _omitFieldNames ? '' : 'reconciliationState')
    ..pPS(27, _omitFieldNames ? '' : 'evidenceRefs')
    ..aOS(28, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$2.Timestamp>(29, _omitFieldNames ? '' : 'orderedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(30, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(31, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(32, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order copyWith(void Function(Order) updates) =>
      super.copyWith((message) => updates(message as Order)) as Order;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Order() / Order.new instead')
  static Order create() => Order._();
  static $pb.GeneratedMessage $_createMessage() => Order._();
  @$core.override
  Order createEmptyInstance() => Order._();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Order>(Order.$_createMessage);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderSourceClass get sourceClass => $_getN(2);
  @$pb.TagNumber(3)
  set sourceClass(OrderSourceClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceClass() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourcePlatform => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourcePlatform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourcePlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourcePlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalOrderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalOrderId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalOrderId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get connectedAccountId => $_getSZ(5);
  @$pb.TagNumber(6)
  set connectedAccountId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConnectedAccountId() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectedAccountId() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Money get taxAmount => $_getN(6);
  @$pb.TagNumber(7)
  set taxAmount($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTaxAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearTaxAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureTaxAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get taxJurisdiction => $_getSZ(7);
  @$pb.TagNumber(8)
  set taxJurisdiction($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTaxJurisdiction() => $_has(7);
  @$pb.TagNumber(8)
  void clearTaxJurisdiction() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get taxNote => $_getSZ(8);
  @$pb.TagNumber(9)
  set taxNote($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTaxNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearTaxNote() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get exchangeRateSnapshotJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set exchangeRateSnapshotJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExchangeRateSnapshotJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearExchangeRateSnapshotJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.Timestamp get recognizedAt => $_getN(10);
  @$pb.TagNumber(11)
  set recognizedAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRecognizedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecognizedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureRecognizedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get sourceUpdatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set sourceUpdatedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureSourceUpdatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get importFingerprint => $_getSZ(12);
  @$pb.TagNumber(13)
  set importFingerprint($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasImportFingerprint() => $_has(12);
  @$pb.TagNumber(13)
  void clearImportFingerprint() => $_clearField(13);

  @$pb.TagNumber(14)
  OrderLifecycleState get lifecycleState => $_getN(13);
  @$pb.TagNumber(14)
  set lifecycleState(OrderLifecycleState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLifecycleState() => $_has(13);
  @$pb.TagNumber(14)
  void clearLifecycleState() => $_clearField(14);

  @$pb.TagNumber(15)
  $1.Money get amount => $_getN(14);
  @$pb.TagNumber(15)
  set amount($1.Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasAmount() => $_has(14);
  @$pb.TagNumber(15)
  void clearAmount() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Money ensureAmount() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get currency => $_getSZ(15);
  @$pb.TagNumber(16)
  set currency($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCurrency() => $_has(15);
  @$pb.TagNumber(16)
  void clearCurrency() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get productId => $_getSZ(16);
  @$pb.TagNumber(17)
  set productId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasProductId() => $_has(16);
  @$pb.TagNumber(17)
  void clearProductId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get offerId => $_getSZ(17);
  @$pb.TagNumber(18)
  set offerId($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasOfferId() => $_has(17);
  @$pb.TagNumber(18)
  void clearOfferId() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get campaignId => $_getSZ(18);
  @$pb.TagNumber(19)
  set campaignId($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCampaignId() => $_has(18);
  @$pb.TagNumber(19)
  void clearCampaignId() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get postId => $_getSZ(19);
  @$pb.TagNumber(20)
  set postId($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasPostId() => $_has(19);
  @$pb.TagNumber(20)
  void clearPostId() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get liveSessionId => $_getSZ(20);
  @$pb.TagNumber(21)
  set liveSessionId($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasLiveSessionId() => $_has(20);
  @$pb.TagNumber(21)
  void clearLiveSessionId() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get customerEntityId => $_getSZ(21);
  @$pb.TagNumber(22)
  set customerEntityId($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasCustomerEntityId() => $_has(21);
  @$pb.TagNumber(22)
  void clearCustomerEntityId() => $_clearField(22);

  @$pb.TagNumber(23)
  $pb.PbList<OrderItem> get items => $_getList(22);

  @$pb.TagNumber(24)
  FeeBreakdown get feeBreakdown => $_getN(23);
  @$pb.TagNumber(24)
  set feeBreakdown(FeeBreakdown value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasFeeBreakdown() => $_has(23);
  @$pb.TagNumber(24)
  void clearFeeBreakdown() => $_clearField(24);
  @$pb.TagNumber(24)
  FeeBreakdown ensureFeeBreakdown() => $_ensure(23);

  @$pb.TagNumber(25)
  $core.String get shippingAddressJson => $_getSZ(24);
  @$pb.TagNumber(25)
  set shippingAddressJson($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasShippingAddressJson() => $_has(24);
  @$pb.TagNumber(25)
  void clearShippingAddressJson() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get reconciliationState => $_getSZ(25);
  @$pb.TagNumber(26)
  set reconciliationState($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasReconciliationState() => $_has(25);
  @$pb.TagNumber(26)
  void clearReconciliationState() => $_clearField(26);

  @$pb.TagNumber(27)
  $pb.PbList<$core.String> get evidenceRefs => $_getList(26);

  @$pb.TagNumber(28)
  $core.String get metadataJson => $_getSZ(27);
  @$pb.TagNumber(28)
  set metadataJson($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasMetadataJson() => $_has(27);
  @$pb.TagNumber(28)
  void clearMetadataJson() => $_clearField(28);

  @$pb.TagNumber(29)
  $2.Timestamp get orderedAt => $_getN(28);
  @$pb.TagNumber(29)
  set orderedAt($2.Timestamp value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasOrderedAt() => $_has(28);
  @$pb.TagNumber(29)
  void clearOrderedAt() => $_clearField(29);
  @$pb.TagNumber(29)
  $2.Timestamp ensureOrderedAt() => $_ensure(28);

  @$pb.TagNumber(30)
  $2.Timestamp get createdAt => $_getN(29);
  @$pb.TagNumber(30)
  set createdAt($2.Timestamp value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasCreatedAt() => $_has(29);
  @$pb.TagNumber(30)
  void clearCreatedAt() => $_clearField(30);
  @$pb.TagNumber(30)
  $2.Timestamp ensureCreatedAt() => $_ensure(29);

  @$pb.TagNumber(31)
  $2.Timestamp get updatedAt => $_getN(30);
  @$pb.TagNumber(31)
  set updatedAt($2.Timestamp value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasUpdatedAt() => $_has(30);
  @$pb.TagNumber(31)
  void clearUpdatedAt() => $_clearField(31);
  @$pb.TagNumber(31)
  $2.Timestamp ensureUpdatedAt() => $_ensure(30);

  @$pb.TagNumber(32)
  $2.Timestamp get deletedAt => $_getN(31);
  @$pb.TagNumber(32)
  set deletedAt($2.Timestamp value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasDeletedAt() => $_has(31);
  @$pb.TagNumber(32)
  void clearDeletedAt() => $_clearField(32);
  @$pb.TagNumber(32)
  $2.Timestamp ensureDeletedAt() => $_ensure(31);
}

/// Inventory physical or virtual location per DB Schema §19.9G.
class InventoryLocation extends $pb.GeneratedMessage {
  factory InventoryLocation({
    $core.String? locationId,
    $core.String? workspaceId,
    $core.String? name,
    $core.String? locationType,
    $core.String? addressJson,
    $core.bool? isDefault,
    $core.String? status,
    $2.Timestamp? createdAt,
  }) {
    final result = InventoryLocation._();
    if (locationId != null) result.locationId = locationId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (locationType != null) result.locationType = locationType;
    if (addressJson != null) result.addressJson = addressJson;
    if (isDefault != null) result.isDefault = isDefault;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  InventoryLocation._();

  factory InventoryLocation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryLocation()..mergeFromBuffer(data, registry);
  factory InventoryLocation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryLocation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryLocation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryLocation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'locationType')
    ..aOS(5, _omitFieldNames ? '' : 'addressJson')
    ..aOB(6, _omitFieldNames ? '' : 'isDefault')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryLocation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryLocation copyWith(void Function(InventoryLocation) updates) =>
      super.copyWith((message) => updates(message as InventoryLocation))
          as InventoryLocation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InventoryLocation() / InventoryLocation.new instead')
  static InventoryLocation create() => InventoryLocation._();
  static $pb.GeneratedMessage $_createMessage() => InventoryLocation._();
  @$core.override
  InventoryLocation createEmptyInstance() => InventoryLocation._();
  @$core.pragma('dart2js:noInline')
  static InventoryLocation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InventoryLocation>(
          InventoryLocation.$_createMessage);
  static InventoryLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationType => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get addressJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set addressJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddressJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddressJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDefault => $_getBF(5);
  @$pb.TagNumber(6)
  set isDefault($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDefault() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDefault() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureCreatedAt() => $_ensure(7);
}

/// Immutable stock movement ledger entry per DB Schema §19.9H.
class StockMovement extends $pb.GeneratedMessage {
  factory StockMovement({
    $core.String? movementId,
    $core.String? workspaceId,
    $core.String? skuId,
    $core.String? locationId,
    StockMovementType? movementType,
    $core.String? movementKey,
    $core.int? quantity,
    $core.String? referenceType,
    $core.String? referenceId,
    $2.Timestamp? sourceCreatedAt,
    $core.String? reason,
    $core.String? metadataJson,
    $2.Timestamp? createdAt,
  }) {
    final result = StockMovement._();
    if (movementId != null) result.movementId = movementId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (skuId != null) result.skuId = skuId;
    if (locationId != null) result.locationId = locationId;
    if (movementType != null) result.movementType = movementType;
    if (movementKey != null) result.movementKey = movementKey;
    if (quantity != null) result.quantity = quantity;
    if (referenceType != null) result.referenceType = referenceType;
    if (referenceId != null) result.referenceId = referenceId;
    if (sourceCreatedAt != null) result.sourceCreatedAt = sourceCreatedAt;
    if (reason != null) result.reason = reason;
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  StockMovement._();

  factory StockMovement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockMovement()..mergeFromBuffer(data, registry);
  factory StockMovement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockMovement()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockMovement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StockMovement.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'movementId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'skuId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aE<StockMovementType>(5, _omitFieldNames ? '' : 'movementType',
        enumValues: StockMovementType.values)
    ..aOS(6, _omitFieldNames ? '' : 'movementKey')
    ..aI(7, _omitFieldNames ? '' : 'quantity')
    ..aOS(8, _omitFieldNames ? '' : 'referenceType')
    ..aOS(9, _omitFieldNames ? '' : 'referenceId')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'sourceCreatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'reason')
    ..aOS(12, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockMovement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockMovement copyWith(void Function(StockMovement) updates) =>
      super.copyWith((message) => updates(message as StockMovement))
          as StockMovement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StockMovement() / StockMovement.new instead')
  static StockMovement create() => StockMovement._();
  static $pb.GeneratedMessage $_createMessage() => StockMovement._();
  @$core.override
  StockMovement createEmptyInstance() => StockMovement._();
  @$core.pragma('dart2js:noInline')
  static StockMovement getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StockMovement>(
          StockMovement.$_createMessage);
  static StockMovement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get movementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set movementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMovementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get skuId => $_getSZ(2);
  @$pb.TagNumber(3)
  set skuId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkuId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkuId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  StockMovementType get movementType => $_getN(4);
  @$pb.TagNumber(5)
  set movementType(StockMovementType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMovementType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMovementType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get movementKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set movementKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMovementKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearMovementKey() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set quantity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get referenceType => $_getSZ(7);
  @$pb.TagNumber(8)
  set referenceType($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReferenceType() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferenceType() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get referenceId => $_getSZ(8);
  @$pb.TagNumber(9)
  set referenceId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReferenceId() => $_has(8);
  @$pb.TagNumber(9)
  void clearReferenceId() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Timestamp get sourceCreatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set sourceCreatedAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSourceCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureSourceCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get reason => $_getSZ(10);
  @$pb.TagNumber(11)
  set reason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get metadataJson => $_getSZ(11);
  @$pb.TagNumber(12)
  set metadataJson($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMetadataJson() => $_has(11);
  @$pb.TagNumber(12)
  void clearMetadataJson() => $_clearField(12);

  @$pb.TagNumber(13)
  $2.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureCreatedAt() => $_ensure(12);
}

/// Rebuildable balance projection per DB Schema §26.11.
class InventoryBalance extends $pb.GeneratedMessage {
  factory InventoryBalance({
    $core.String? balanceId,
    $core.String? workspaceId,
    $core.String? skuId,
    $core.String? locationId,
    $core.int? onHand,
    $core.int? reserved,
    $2.Timestamp? openingAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = InventoryBalance._();
    if (balanceId != null) result.balanceId = balanceId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (skuId != null) result.skuId = skuId;
    if (locationId != null) result.locationId = locationId;
    if (onHand != null) result.onHand = onHand;
    if (reserved != null) result.reserved = reserved;
    if (openingAt != null) result.openingAt = openingAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  InventoryBalance._();

  factory InventoryBalance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryBalance()..mergeFromBuffer(data, registry);
  factory InventoryBalance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryBalance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryBalance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryBalance.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'balanceId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'skuId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aI(5, _omitFieldNames ? '' : 'onHand')
    ..aI(6, _omitFieldNames ? '' : 'reserved')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'openingAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryBalance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryBalance copyWith(void Function(InventoryBalance) updates) =>
      super.copyWith((message) => updates(message as InventoryBalance))
          as InventoryBalance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InventoryBalance() / InventoryBalance.new instead')
  static InventoryBalance create() => InventoryBalance._();
  static $pb.GeneratedMessage $_createMessage() => InventoryBalance._();
  @$core.override
  InventoryBalance createEmptyInstance() => InventoryBalance._();
  @$core.pragma('dart2js:noInline')
  static InventoryBalance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InventoryBalance>(
          InventoryBalance.$_createMessage);
  static InventoryBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get balanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set balanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBalanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get skuId => $_getSZ(2);
  @$pb.TagNumber(3)
  set skuId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkuId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkuId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get onHand => $_getIZ(4);
  @$pb.TagNumber(5)
  set onHand($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOnHand() => $_has(4);
  @$pb.TagNumber(5)
  void clearOnHand() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get reserved => $_getIZ(5);
  @$pb.TagNumber(6)
  set reserved($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReserved() => $_has(5);
  @$pb.TagNumber(6)
  void clearReserved() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get openingAt => $_getN(6);
  @$pb.TagNumber(7)
  set openingAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOpeningAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearOpeningAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureOpeningAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureUpdatedAt() => $_ensure(7);
}

/// Durable stock hold reservation per DB Schema §26.12.
class StockReservation extends $pb.GeneratedMessage {
  factory StockReservation({
    $core.String? reservationId,
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? skuId,
    $core.String? locationId,
    $core.String? reservationKey,
    $core.int? quantity,
    StockReservationStatus? status,
    $2.Timestamp? expiresAt,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = StockReservation._();
    if (reservationId != null) result.reservationId = reservationId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (skuId != null) result.skuId = skuId;
    if (locationId != null) result.locationId = locationId;
    if (reservationKey != null) result.reservationKey = reservationKey;
    if (quantity != null) result.quantity = quantity;
    if (status != null) result.status = status;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  StockReservation._();

  factory StockReservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockReservation()..mergeFromBuffer(data, registry);
  factory StockReservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockReservation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockReservation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StockReservation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'skuId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'reservationKey')
    ..aI(7, _omitFieldNames ? '' : 'quantity')
    ..aE<StockReservationStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: StockReservationStatus.values)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockReservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockReservation copyWith(void Function(StockReservation) updates) =>
      super.copyWith((message) => updates(message as StockReservation))
          as StockReservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StockReservation() / StockReservation.new instead')
  static StockReservation create() => StockReservation._();
  static $pb.GeneratedMessage $_createMessage() => StockReservation._();
  @$core.override
  StockReservation createEmptyInstance() => StockReservation._();
  @$core.pragma('dart2js:noInline')
  static StockReservation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StockReservation>(
          StockReservation.$_createMessage);
  static StockReservation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get skuId => $_getSZ(3);
  @$pb.TagNumber(4)
  set skuId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSkuId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSkuId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reservationKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set reservationKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReservationKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearReservationKey() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set quantity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  StockReservationStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(StockReservationStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Timestamp get expiresAt => $_getN(8);
  @$pb.TagNumber(9)
  set expiresAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureExpiresAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureUpdatedAt() => $_ensure(10);
}

/// Financial refund reversal record per DB Schema §19.5.
class Refund extends $pb.GeneratedMessage {
  factory Refund({
    $core.String? refundId,
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? refundType,
    $1.Money? amount,
    $core.String? currency,
    $core.String? reason,
    RefundLifecycleState? lifecycleState,
    OrderSourceClass? sourceClass,
    $core.String? sourcePlatform,
    $core.String? externalRefundId,
    $core.String? settlementId,
    $core.Iterable<$core.String>? evidenceRefs,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $2.Timestamp? deletedAt,
  }) {
    final result = Refund._();
    if (refundId != null) result.refundId = refundId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (refundType != null) result.refundType = refundType;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (reason != null) result.reason = reason;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (externalRefundId != null) result.externalRefundId = externalRefundId;
    if (settlementId != null) result.settlementId = settlementId;
    if (evidenceRefs != null) result.evidenceRefs.addAll(evidenceRefs);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  Refund._();

  factory Refund.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Refund()..mergeFromBuffer(data, registry);
  factory Refund.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Refund()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Refund',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Refund.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'refundId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'refundType')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aE<RefundLifecycleState>(8, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: RefundLifecycleState.values)
    ..aE<OrderSourceClass>(9, _omitFieldNames ? '' : 'sourceClass',
        enumValues: OrderSourceClass.values)
    ..aOS(10, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(11, _omitFieldNames ? '' : 'externalRefundId')
    ..aOS(12, _omitFieldNames ? '' : 'settlementId')
    ..pPS(13, _omitFieldNames ? '' : 'evidenceRefs')
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(16, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Refund clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Refund copyWith(void Function(Refund) updates) =>
      super.copyWith((message) => updates(message as Refund)) as Refund;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Refund() / Refund.new instead')
  static Refund create() => Refund._();
  static $pb.GeneratedMessage $_createMessage() => Refund._();
  @$core.override
  Refund createEmptyInstance() => Refund._();
  @$core.pragma('dart2js:noInline')
  static Refund getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Refund>(Refund.$_createMessage);
  static Refund? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refundId => $_getSZ(0);
  @$pb.TagNumber(1)
  set refundId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefundId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefundId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get refundType => $_getSZ(3);
  @$pb.TagNumber(4)
  set refundType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRefundType() => $_has(3);
  @$pb.TagNumber(4)
  void clearRefundType() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  RefundLifecycleState get lifecycleState => $_getN(7);
  @$pb.TagNumber(8)
  set lifecycleState(RefundLifecycleState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLifecycleState() => $_has(7);
  @$pb.TagNumber(8)
  void clearLifecycleState() => $_clearField(8);

  @$pb.TagNumber(9)
  OrderSourceClass get sourceClass => $_getN(8);
  @$pb.TagNumber(9)
  set sourceClass(OrderSourceClass value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSourceClass() => $_has(8);
  @$pb.TagNumber(9)
  void clearSourceClass() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourcePlatform => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourcePlatform($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSourcePlatform() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourcePlatform() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get externalRefundId => $_getSZ(10);
  @$pb.TagNumber(11)
  set externalRefundId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExternalRefundId() => $_has(10);
  @$pb.TagNumber(11)
  void clearExternalRefundId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get settlementId => $_getSZ(11);
  @$pb.TagNumber(12)
  set settlementId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSettlementId() => $_has(11);
  @$pb.TagNumber(12)
  void clearSettlementId() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get evidenceRefs => $_getList(12);

  @$pb.TagNumber(14)
  $2.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureCreatedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $2.Timestamp get updatedAt => $_getN(14);
  @$pb.TagNumber(15)
  set updatedAt($2.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $2.Timestamp ensureUpdatedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $2.Timestamp get deletedAt => $_getN(15);
  @$pb.TagNumber(16)
  set deletedAt($2.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasDeletedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearDeletedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Timestamp ensureDeletedAt() => $_ensure(15);
}

/// Return item details.
class ReturnItem extends $pb.GeneratedMessage {
  factory ReturnItem({
    $core.String? sku,
    $core.int? quantity,
    $core.String? reason,
  }) {
    final result = ReturnItem._();
    if (sku != null) result.sku = sku;
    if (quantity != null) result.quantity = quantity;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReturnItem._();

  factory ReturnItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReturnItem()..mergeFromBuffer(data, registry);
  factory ReturnItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReturnItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReturnItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ReturnItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sku')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnItem copyWith(void Function(ReturnItem) updates) =>
      super.copyWith((message) => updates(message as ReturnItem)) as ReturnItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReturnItem() / ReturnItem.new instead')
  static ReturnItem create() => ReturnItem._();
  static $pb.GeneratedMessage $_createMessage() => ReturnItem._();
  @$core.override
  ReturnItem createEmptyInstance() => ReturnItem._();
  @$core.pragma('dart2js:noInline')
  static ReturnItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReturnItem>(ReturnItem.$_createMessage);
  static ReturnItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sku => $_getSZ(0);
  @$pb.TagNumber(1)
  set sku($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSku() => $_has(0);
  @$pb.TagNumber(1)
  void clearSku() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

/// Logistics/physical return reversal per DB Schema §19.6.
class Return extends $pb.GeneratedMessage {
  factory Return({
    $core.String? returnId,
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? refundId,
    $core.String? returnType,
    $core.Iterable<ReturnItem>? items,
    ReturnLifecycleState? lifecycleState,
    $core.String? trackingNumber,
    $core.String? evidencePhotoUrl,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $2.Timestamp? deletedAt,
  }) {
    final result = Return._();
    if (returnId != null) result.returnId = returnId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (refundId != null) result.refundId = refundId;
    if (returnType != null) result.returnType = returnType;
    if (items != null) result.items.addAll(items);
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (evidencePhotoUrl != null) result.evidencePhotoUrl = evidencePhotoUrl;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  Return._();

  factory Return.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Return()..mergeFromBuffer(data, registry);
  factory Return.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Return()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Return',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Return.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'returnId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'refundId')
    ..aOS(5, _omitFieldNames ? '' : 'returnType')
    ..pPM<ReturnItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: ReturnItem.$_createMessage)
    ..aE<ReturnLifecycleState>(7, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: ReturnLifecycleState.values)
    ..aOS(8, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(9, _omitFieldNames ? '' : 'evidencePhotoUrl')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Return clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Return copyWith(void Function(Return) updates) =>
      super.copyWith((message) => updates(message as Return)) as Return;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Return() / Return.new instead')
  static Return create() => Return._();
  static $pb.GeneratedMessage $_createMessage() => Return._();
  @$core.override
  Return createEmptyInstance() => Return._();
  @$core.pragma('dart2js:noInline')
  static Return getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Return>(Return.$_createMessage);
  static Return? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get returnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set returnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReturnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReturnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get refundId => $_getSZ(3);
  @$pb.TagNumber(4)
  set refundId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRefundId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRefundId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get returnType => $_getSZ(4);
  @$pb.TagNumber(5)
  set returnType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReturnType() => $_has(4);
  @$pb.TagNumber(5)
  void clearReturnType() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ReturnItem> get items => $_getList(5);

  @$pb.TagNumber(7)
  ReturnLifecycleState get lifecycleState => $_getN(6);
  @$pb.TagNumber(7)
  set lifecycleState(ReturnLifecycleState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLifecycleState() => $_has(6);
  @$pb.TagNumber(7)
  void clearLifecycleState() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get trackingNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set trackingNumber($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrackingNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrackingNumber() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get evidencePhotoUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set evidencePhotoUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEvidencePhotoUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvidencePhotoUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureUpdatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get deletedAt => $_getN(11);
  @$pb.TagNumber(12)
  set deletedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDeletedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeletedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureDeletedAt() => $_ensure(11);
}

/// Helper types for inventory batch operations and alerts.
class StockMovementItem extends $pb.GeneratedMessage {
  factory StockMovementItem({
    $core.String? skuId,
    $core.int? quantity,
  }) {
    final result = StockMovementItem._();
    if (skuId != null) result.skuId = skuId;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  StockMovementItem._();

  factory StockMovementItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockMovementItem()..mergeFromBuffer(data, registry);
  factory StockMovementItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StockMovementItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockMovementItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StockMovementItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockMovementItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockMovementItem copyWith(void Function(StockMovementItem) updates) =>
      super.copyWith((message) => updates(message as StockMovementItem))
          as StockMovementItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StockMovementItem() / StockMovementItem.new instead')
  static StockMovementItem create() => StockMovementItem._();
  static $pb.GeneratedMessage $_createMessage() => StockMovementItem._();
  @$core.override
  StockMovementItem createEmptyInstance() => StockMovementItem._();
  @$core.pragma('dart2js:noInline')
  static StockMovementItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StockMovementItem>(
          StockMovementItem.$_createMessage);
  static StockMovementItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

class InventoryAlert extends $pb.GeneratedMessage {
  factory InventoryAlert({
    $core.String? skuId,
    $core.String? productTitle,
    $core.String? skuCode,
    $core.int? currentStock,
    $core.int? threshold,
    $core.String? alertLevel,
  }) {
    final result = InventoryAlert._();
    if (skuId != null) result.skuId = skuId;
    if (productTitle != null) result.productTitle = productTitle;
    if (skuCode != null) result.skuCode = skuCode;
    if (currentStock != null) result.currentStock = currentStock;
    if (threshold != null) result.threshold = threshold;
    if (alertLevel != null) result.alertLevel = alertLevel;
    return result;
  }

  InventoryAlert._();

  factory InventoryAlert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryAlert()..mergeFromBuffer(data, registry);
  factory InventoryAlert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryAlert()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryAlert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryAlert.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aOS(2, _omitFieldNames ? '' : 'productTitle')
    ..aOS(3, _omitFieldNames ? '' : 'skuCode')
    ..aI(4, _omitFieldNames ? '' : 'currentStock')
    ..aI(5, _omitFieldNames ? '' : 'threshold')
    ..aOS(6, _omitFieldNames ? '' : 'alertLevel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryAlert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryAlert copyWith(void Function(InventoryAlert) updates) =>
      super.copyWith((message) => updates(message as InventoryAlert))
          as InventoryAlert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InventoryAlert() / InventoryAlert.new instead')
  static InventoryAlert create() => InventoryAlert._();
  static $pb.GeneratedMessage $_createMessage() => InventoryAlert._();
  @$core.override
  InventoryAlert createEmptyInstance() => InventoryAlert._();
  @$core.pragma('dart2js:noInline')
  static InventoryAlert getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InventoryAlert>(
          InventoryAlert.$_createMessage);
  static InventoryAlert? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get productTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set productTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get skuCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set skuCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkuCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkuCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get currentStock => $_getIZ(3);
  @$pb.TagNumber(4)
  set currentStock($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentStock() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentStock() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get threshold => $_getIZ(4);
  @$pb.TagNumber(5)
  set threshold($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThreshold() => $_has(4);
  @$pb.TagNumber(5)
  void clearThreshold() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get alertLevel => $_getSZ(5);
  @$pb.TagNumber(6)
  set alertLevel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAlertLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearAlertLevel() => $_clearField(6);
}

class OrderServiceListRequest extends $pb.GeneratedMessage {
  factory OrderServiceListRequest({
    $1.Pagination? pagination,
    OrderLifecycleState? state,
    $core.String? sourcePlatform,
    $core.String? dateFrom,
    $core.String? dateTo,
  }) {
    final result = OrderServiceListRequest._();
    if (pagination != null) result.pagination = pagination;
    if (state != null) result.state = state;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (dateFrom != null) result.dateFrom = dateFrom;
    if (dateTo != null) result.dateTo = dateTo;
    return result;
  }

  OrderServiceListRequest._();

  factory OrderServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceListRequest.$_createMessage)
    ..aOM<$1.Pagination>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aE<OrderLifecycleState>(2, _omitFieldNames ? '' : 'state',
        enumValues: OrderLifecycleState.values)
    ..aOS(3, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(4, _omitFieldNames ? '' : 'dateFrom')
    ..aOS(5, _omitFieldNames ? '' : 'dateTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRequest copyWith(
          void Function(OrderServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as OrderServiceListRequest))
          as OrderServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceListRequest() / OrderServiceListRequest.new instead')
  static OrderServiceListRequest create() => OrderServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => OrderServiceListRequest._();
  @$core.override
  OrderServiceListRequest createEmptyInstance() => OrderServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceListRequest>(
          OrderServiceListRequest.$_createMessage);
  static OrderServiceListRequest? _defaultInstance;

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
  OrderLifecycleState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(OrderLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourcePlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourcePlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourcePlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourcePlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get dateFrom => $_getSZ(3);
  @$pb.TagNumber(4)
  set dateFrom($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDateFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearDateFrom() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dateTo => $_getSZ(4);
  @$pb.TagNumber(5)
  set dateTo($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDateTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearDateTo() => $_clearField(5);
}

class OrderServiceListResponse extends $pb.GeneratedMessage {
  factory OrderServiceListResponse({
    $core.Iterable<Order>? orders,
    $1.PaginatedResponse? pagination,
  }) {
    final result = OrderServiceListResponse._();
    if (orders != null) result.orders.addAll(orders);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  OrderServiceListResponse._();

  factory OrderServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceListResponse.$_createMessage)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: Order.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListResponse copyWith(
          void Function(OrderServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as OrderServiceListResponse))
          as OrderServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceListResponse() / OrderServiceListResponse.new instead')
  static OrderServiceListResponse create() => OrderServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => OrderServiceListResponse._();
  @$core.override
  OrderServiceListResponse createEmptyInstance() =>
      OrderServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceListResponse>(
          OrderServiceListResponse.$_createMessage);
  static OrderServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);

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

class OrderServiceGetRequest extends $pb.GeneratedMessage {
  factory OrderServiceGetRequest({
    $core.String? orderId,
  }) {
    final result = OrderServiceGetRequest._();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  OrderServiceGetRequest._();

  factory OrderServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetRequest copyWith(
          void Function(OrderServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as OrderServiceGetRequest))
          as OrderServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetRequest() / OrderServiceGetRequest.new instead')
  static OrderServiceGetRequest create() => OrderServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => OrderServiceGetRequest._();
  @$core.override
  OrderServiceGetRequest createEmptyInstance() => OrderServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetRequest>(
          OrderServiceGetRequest.$_createMessage);
  static OrderServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
}

class OrderServiceGetResponse extends $pb.GeneratedMessage {
  factory OrderServiceGetResponse({
    Order? order,
    $core.Iterable<Refund>? refunds,
    $core.Iterable<Return>? returns,
    $core.Iterable<StockReservation>? reservations,
  }) {
    final result = OrderServiceGetResponse._();
    if (order != null) result.order = order;
    if (refunds != null) result.refunds.addAll(refunds);
    if (returns != null) result.returns.addAll(returns);
    if (reservations != null) result.reservations.addAll(reservations);
    return result;
  }

  OrderServiceGetResponse._();

  factory OrderServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetResponse.$_createMessage)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..pPM<Refund>(2, _omitFieldNames ? '' : 'refunds',
        subBuilder: Refund.$_createMessage)
    ..pPM<Return>(3, _omitFieldNames ? '' : 'returns',
        subBuilder: Return.$_createMessage)
    ..pPM<StockReservation>(4, _omitFieldNames ? '' : 'reservations',
        subBuilder: StockReservation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetResponse copyWith(
          void Function(OrderServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as OrderServiceGetResponse))
          as OrderServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetResponse() / OrderServiceGetResponse.new instead')
  static OrderServiceGetResponse create() => OrderServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => OrderServiceGetResponse._();
  @$core.override
  OrderServiceGetResponse createEmptyInstance() => OrderServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetResponse>(
          OrderServiceGetResponse.$_createMessage);
  static OrderServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Refund> get refunds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Return> get returns => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<StockReservation> get reservations => $_getList(3);
}

class OrderServiceImportRequest extends $pb.GeneratedMessage {
  factory OrderServiceImportRequest({
    $1.CommandContext? context,
    $core.String? connectedAccountId,
    $core.String? platform,
    $core.String? sourceData,
    $core.String? format,
    $core.String? previewToken,
    $core.bool? dryRun,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? columnMappings,
  }) {
    final result = OrderServiceImportRequest._();
    if (context != null) result.context = context;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (platform != null) result.platform = platform;
    if (sourceData != null) result.sourceData = sourceData;
    if (format != null) result.format = format;
    if (previewToken != null) result.previewToken = previewToken;
    if (dryRun != null) result.dryRun = dryRun;
    if (columnMappings != null)
      result.columnMappings.addEntries(columnMappings);
    return result;
  }

  OrderServiceImportRequest._();

  factory OrderServiceImportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceImportRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceImportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceImportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceImportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceImportRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'sourceData')
    ..aOS(5, _omitFieldNames ? '' : 'format')
    ..aOS(6, _omitFieldNames ? '' : 'previewToken')
    ..aOB(7, _omitFieldNames ? '' : 'dryRun')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'columnMappings',
        entryClassName: 'OrderServiceImportRequest.ColumnMappingsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.commerce.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceImportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceImportRequest copyWith(
          void Function(OrderServiceImportRequest) updates) =>
      super.copyWith((message) => updates(message as OrderServiceImportRequest))
          as OrderServiceImportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceImportRequest() / OrderServiceImportRequest.new instead')
  static OrderServiceImportRequest create() => OrderServiceImportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceImportRequest._();
  @$core.override
  OrderServiceImportRequest createEmptyInstance() =>
      OrderServiceImportRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceImportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceImportRequest>(
          OrderServiceImportRequest.$_createMessage);
  static OrderServiceImportRequest? _defaultInstance;

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
  $core.String get connectedAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connectedAccountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceData => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceData($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceData() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceData() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get format => $_getSZ(4);
  @$pb.TagNumber(5)
  set format($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get previewToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set previewToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPreviewToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPreviewToken() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get dryRun => $_getBF(6);
  @$pb.TagNumber(7)
  set dryRun($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDryRun() => $_has(6);
  @$pb.TagNumber(7)
  void clearDryRun() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get columnMappings => $_getMap(7);
}

class OrderServiceImportResponse extends $pb.GeneratedMessage {
  factory OrderServiceImportResponse({
    $core.bool? isPreview,
    $core.String? previewToken,
    $core.int? totalRows,
    $core.int? createCount,
    $core.int? updateCount,
    $core.int? unchangedCount,
    $core.int? errorCount,
    $core.Iterable<Order>? createdOrders,
    $core.String? importFingerprint,
  }) {
    final result = OrderServiceImportResponse._();
    if (isPreview != null) result.isPreview = isPreview;
    if (previewToken != null) result.previewToken = previewToken;
    if (totalRows != null) result.totalRows = totalRows;
    if (createCount != null) result.createCount = createCount;
    if (updateCount != null) result.updateCount = updateCount;
    if (unchangedCount != null) result.unchangedCount = unchangedCount;
    if (errorCount != null) result.errorCount = errorCount;
    if (createdOrders != null) result.createdOrders.addAll(createdOrders);
    if (importFingerprint != null) result.importFingerprint = importFingerprint;
    return result;
  }

  OrderServiceImportResponse._();

  factory OrderServiceImportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceImportResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceImportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceImportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceImportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceImportResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isPreview')
    ..aOS(2, _omitFieldNames ? '' : 'previewToken')
    ..aI(3, _omitFieldNames ? '' : 'totalRows')
    ..aI(4, _omitFieldNames ? '' : 'createCount')
    ..aI(5, _omitFieldNames ? '' : 'updateCount')
    ..aI(6, _omitFieldNames ? '' : 'unchangedCount')
    ..aI(7, _omitFieldNames ? '' : 'errorCount')
    ..pPM<Order>(8, _omitFieldNames ? '' : 'createdOrders',
        subBuilder: Order.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'importFingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceImportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceImportResponse copyWith(
          void Function(OrderServiceImportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceImportResponse))
          as OrderServiceImportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceImportResponse() / OrderServiceImportResponse.new instead')
  static OrderServiceImportResponse create() => OrderServiceImportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceImportResponse._();
  @$core.override
  OrderServiceImportResponse createEmptyInstance() =>
      OrderServiceImportResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceImportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceImportResponse>(
          OrderServiceImportResponse.$_createMessage);
  static OrderServiceImportResponse? _defaultInstance;

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
  $pb.PbList<Order> get createdOrders => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get importFingerprint => $_getSZ(8);
  @$pb.TagNumber(9)
  set importFingerprint($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasImportFingerprint() => $_has(8);
  @$pb.TagNumber(9)
  void clearImportFingerprint() => $_clearField(9);
}

class OrderServiceExportRequest extends $pb.GeneratedMessage {
  factory OrderServiceExportRequest({
    $core.String? format,
    OrderLifecycleState? state,
    $core.String? dateFrom,
    $core.String? dateTo,
  }) {
    final result = OrderServiceExportRequest._();
    if (format != null) result.format = format;
    if (state != null) result.state = state;
    if (dateFrom != null) result.dateFrom = dateFrom;
    if (dateTo != null) result.dateTo = dateTo;
    return result;
  }

  OrderServiceExportRequest._();

  factory OrderServiceExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceExportRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceExportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceExportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'format')
    ..aE<OrderLifecycleState>(2, _omitFieldNames ? '' : 'state',
        enumValues: OrderLifecycleState.values)
    ..aOS(3, _omitFieldNames ? '' : 'dateFrom')
    ..aOS(4, _omitFieldNames ? '' : 'dateTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceExportRequest copyWith(
          void Function(OrderServiceExportRequest) updates) =>
      super.copyWith((message) => updates(message as OrderServiceExportRequest))
          as OrderServiceExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceExportRequest() / OrderServiceExportRequest.new instead')
  static OrderServiceExportRequest create() => OrderServiceExportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceExportRequest._();
  @$core.override
  OrderServiceExportRequest createEmptyInstance() =>
      OrderServiceExportRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceExportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceExportRequest>(
          OrderServiceExportRequest.$_createMessage);
  static OrderServiceExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get format => $_getSZ(0);
  @$pb.TagNumber(1)
  set format($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormat() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormat() => $_clearField(1);

  @$pb.TagNumber(2)
  OrderLifecycleState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(OrderLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get dateFrom => $_getSZ(2);
  @$pb.TagNumber(3)
  set dateFrom($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDateFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearDateFrom() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get dateTo => $_getSZ(3);
  @$pb.TagNumber(4)
  set dateTo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDateTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearDateTo() => $_clearField(4);
}

class OrderServiceExportResponse extends $pb.GeneratedMessage {
  factory OrderServiceExportResponse({
    $core.String? downloadUrl,
    $core.int? rowCount,
  }) {
    final result = OrderServiceExportResponse._();
    if (downloadUrl != null) result.downloadUrl = downloadUrl;
    if (rowCount != null) result.rowCount = rowCount;
    return result;
  }

  OrderServiceExportResponse._();

  factory OrderServiceExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceExportResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceExportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceExportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'downloadUrl')
    ..aI(2, _omitFieldNames ? '' : 'rowCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceExportResponse copyWith(
          void Function(OrderServiceExportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceExportResponse))
          as OrderServiceExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceExportResponse() / OrderServiceExportResponse.new instead')
  static OrderServiceExportResponse create() => OrderServiceExportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceExportResponse._();
  @$core.override
  OrderServiceExportResponse createEmptyInstance() =>
      OrderServiceExportResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceExportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceExportResponse>(
          OrderServiceExportResponse.$_createMessage);
  static OrderServiceExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get downloadUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set downloadUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDownloadUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearDownloadUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rowCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set rowCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRowCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRowCount() => $_clearField(2);
}

class OrderServiceUpdateStatusRequest extends $pb.GeneratedMessage {
  factory OrderServiceUpdateStatusRequest({
    $1.CommandContext? context,
    $core.String? orderId,
    OrderLifecycleState? targetState,
    $core.String? reason,
  }) {
    final result = OrderServiceUpdateStatusRequest._();
    if (context != null) result.context = context;
    if (orderId != null) result.orderId = orderId;
    if (targetState != null) result.targetState = targetState;
    if (reason != null) result.reason = reason;
    return result;
  }

  OrderServiceUpdateStatusRequest._();

  factory OrderServiceUpdateStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceUpdateStatusRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aE<OrderLifecycleState>(3, _omitFieldNames ? '' : 'targetState',
        enumValues: OrderLifecycleState.values)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceUpdateStatusRequest copyWith(
          void Function(OrderServiceUpdateStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceUpdateStatusRequest))
          as OrderServiceUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceUpdateStatusRequest() / OrderServiceUpdateStatusRequest.new instead')
  static OrderServiceUpdateStatusRequest create() =>
      OrderServiceUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceUpdateStatusRequest._();
  @$core.override
  OrderServiceUpdateStatusRequest createEmptyInstance() =>
      OrderServiceUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceUpdateStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceUpdateStatusRequest>(
          OrderServiceUpdateStatusRequest.$_createMessage);
  static OrderServiceUpdateStatusRequest? _defaultInstance;

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
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderLifecycleState get targetState => $_getN(2);
  @$pb.TagNumber(3)
  set targetState(OrderLifecycleState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetState() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class OrderServiceUpdateStatusResponse extends $pb.GeneratedMessage {
  factory OrderServiceUpdateStatusResponse({
    Order? order,
  }) {
    final result = OrderServiceUpdateStatusResponse._();
    if (order != null) result.order = order;
    return result;
  }

  OrderServiceUpdateStatusResponse._();

  factory OrderServiceUpdateStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceUpdateStatusResponse.$_createMessage)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceUpdateStatusResponse copyWith(
          void Function(OrderServiceUpdateStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceUpdateStatusResponse))
          as OrderServiceUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceUpdateStatusResponse() / OrderServiceUpdateStatusResponse.new instead')
  static OrderServiceUpdateStatusResponse create() =>
      OrderServiceUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceUpdateStatusResponse._();
  @$core.override
  OrderServiceUpdateStatusResponse createEmptyInstance() =>
      OrderServiceUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceUpdateStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceUpdateStatusResponse>(
          OrderServiceUpdateStatusResponse.$_createMessage);
  static OrderServiceUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);
}

class OrderServiceSearchRequest extends $pb.GeneratedMessage {
  factory OrderServiceSearchRequest({
    $core.String? query,
    $1.Pagination? pagination,
  }) {
    final result = OrderServiceSearchRequest._();
    if (query != null) result.query = query;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  OrderServiceSearchRequest._();

  factory OrderServiceSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceSearchRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceSearchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceSearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceSearchRequest copyWith(
          void Function(OrderServiceSearchRequest) updates) =>
      super.copyWith((message) => updates(message as OrderServiceSearchRequest))
          as OrderServiceSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceSearchRequest() / OrderServiceSearchRequest.new instead')
  static OrderServiceSearchRequest create() => OrderServiceSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceSearchRequest._();
  @$core.override
  OrderServiceSearchRequest createEmptyInstance() =>
      OrderServiceSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceSearchRequest>(
          OrderServiceSearchRequest.$_createMessage);
  static OrderServiceSearchRequest? _defaultInstance;

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

class OrderServiceSearchResponse extends $pb.GeneratedMessage {
  factory OrderServiceSearchResponse({
    $core.Iterable<Order>? orders,
    $1.PaginatedResponse? pagination,
  }) {
    final result = OrderServiceSearchResponse._();
    if (orders != null) result.orders.addAll(orders);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  OrderServiceSearchResponse._();

  factory OrderServiceSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceSearchResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceSearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceSearchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceSearchResponse.$_createMessage)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: Order.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceSearchResponse copyWith(
          void Function(OrderServiceSearchResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceSearchResponse))
          as OrderServiceSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceSearchResponse() / OrderServiceSearchResponse.new instead')
  static OrderServiceSearchResponse create() => OrderServiceSearchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceSearchResponse._();
  @$core.override
  OrderServiceSearchResponse createEmptyInstance() =>
      OrderServiceSearchResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceSearchResponse>(
          OrderServiceSearchResponse.$_createMessage);
  static OrderServiceSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);

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

class OrderServiceConfirmRequest extends $pb.GeneratedMessage {
  factory OrderServiceConfirmRequest({
    $1.CommandContext? context,
    $core.String? orderId,
  }) {
    final result = OrderServiceConfirmRequest._();
    if (context != null) result.context = context;
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  OrderServiceConfirmRequest._();

  factory OrderServiceConfirmRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceConfirmRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceConfirmRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceConfirmRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceConfirmRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceConfirmRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceConfirmRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceConfirmRequest copyWith(
          void Function(OrderServiceConfirmRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceConfirmRequest))
          as OrderServiceConfirmRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceConfirmRequest() / OrderServiceConfirmRequest.new instead')
  static OrderServiceConfirmRequest create() => OrderServiceConfirmRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceConfirmRequest._();
  @$core.override
  OrderServiceConfirmRequest createEmptyInstance() =>
      OrderServiceConfirmRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceConfirmRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceConfirmRequest>(
          OrderServiceConfirmRequest.$_createMessage);
  static OrderServiceConfirmRequest? _defaultInstance;

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
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);
}

class OrderServiceConfirmResponse extends $pb.GeneratedMessage {
  factory OrderServiceConfirmResponse({
    Order? order,
  }) {
    final result = OrderServiceConfirmResponse._();
    if (order != null) result.order = order;
    return result;
  }

  OrderServiceConfirmResponse._();

  factory OrderServiceConfirmResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceConfirmResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceConfirmResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceConfirmResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceConfirmResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceConfirmResponse.$_createMessage)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order',
        subBuilder: Order.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceConfirmResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceConfirmResponse copyWith(
          void Function(OrderServiceConfirmResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceConfirmResponse))
          as OrderServiceConfirmResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceConfirmResponse() / OrderServiceConfirmResponse.new instead')
  static OrderServiceConfirmResponse create() =>
      OrderServiceConfirmResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceConfirmResponse._();
  @$core.override
  OrderServiceConfirmResponse createEmptyInstance() =>
      OrderServiceConfirmResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceConfirmResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceConfirmResponse>(
          OrderServiceConfirmResponse.$_createMessage);
  static OrderServiceConfirmResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);
}

class OrderServiceGetTodayStatsRequest extends $pb.GeneratedMessage {
  factory OrderServiceGetTodayStatsRequest() =>
      OrderServiceGetTodayStatsRequest._();

  OrderServiceGetTodayStatsRequest._();

  factory OrderServiceGetTodayStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetTodayStatsRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceGetTodayStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetTodayStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetTodayStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetTodayStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetTodayStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetTodayStatsRequest copyWith(
          void Function(OrderServiceGetTodayStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceGetTodayStatsRequest))
          as OrderServiceGetTodayStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetTodayStatsRequest() / OrderServiceGetTodayStatsRequest.new instead')
  static OrderServiceGetTodayStatsRequest create() =>
      OrderServiceGetTodayStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetTodayStatsRequest._();
  @$core.override
  OrderServiceGetTodayStatsRequest createEmptyInstance() =>
      OrderServiceGetTodayStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetTodayStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetTodayStatsRequest>(
          OrderServiceGetTodayStatsRequest.$_createMessage);
  static OrderServiceGetTodayStatsRequest? _defaultInstance;
}

class OrderServiceGetTodayStatsResponse extends $pb.GeneratedMessage {
  factory OrderServiceGetTodayStatsResponse({
    $core.int? orderCount,
    $1.Money? totalAmount,
    $core.int? pendingFulfillmentCount,
  }) {
    final result = OrderServiceGetTodayStatsResponse._();
    if (orderCount != null) result.orderCount = orderCount;
    if (totalAmount != null) result.totalAmount = totalAmount;
    if (pendingFulfillmentCount != null)
      result.pendingFulfillmentCount = pendingFulfillmentCount;
    return result;
  }

  OrderServiceGetTodayStatsResponse._();

  factory OrderServiceGetTodayStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetTodayStatsResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceGetTodayStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetTodayStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetTodayStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetTodayStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'orderCount')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'totalAmount',
        subBuilder: $1.Money.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'pendingFulfillmentCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetTodayStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetTodayStatsResponse copyWith(
          void Function(OrderServiceGetTodayStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OrderServiceGetTodayStatsResponse))
          as OrderServiceGetTodayStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetTodayStatsResponse() / OrderServiceGetTodayStatsResponse.new instead')
  static OrderServiceGetTodayStatsResponse create() =>
      OrderServiceGetTodayStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetTodayStatsResponse._();
  @$core.override
  OrderServiceGetTodayStatsResponse createEmptyInstance() =>
      OrderServiceGetTodayStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetTodayStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetTodayStatsResponse>(
          OrderServiceGetTodayStatsResponse.$_createMessage);
  static OrderServiceGetTodayStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get orderCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set orderCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Money get totalAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalAmount($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensureTotalAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get pendingFulfillmentCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set pendingFulfillmentCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingFulfillmentCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingFulfillmentCount() => $_clearField(3);
}

class OrderServiceGetDailyStatsRequest extends $pb.GeneratedMessage {
  factory OrderServiceGetDailyStatsRequest({
    $core.String? date,
  }) {
    final result = OrderServiceGetDailyStatsRequest._();
    if (date != null) result.date = date;
    return result;
  }

  OrderServiceGetDailyStatsRequest._();

  factory OrderServiceGetDailyStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetDailyStatsRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceGetDailyStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetDailyStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetDailyStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetDailyStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetDailyStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetDailyStatsRequest copyWith(
          void Function(OrderServiceGetDailyStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceGetDailyStatsRequest))
          as OrderServiceGetDailyStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetDailyStatsRequest() / OrderServiceGetDailyStatsRequest.new instead')
  static OrderServiceGetDailyStatsRequest create() =>
      OrderServiceGetDailyStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetDailyStatsRequest._();
  @$core.override
  OrderServiceGetDailyStatsRequest createEmptyInstance() =>
      OrderServiceGetDailyStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetDailyStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetDailyStatsRequest>(
          OrderServiceGetDailyStatsRequest.$_createMessage);
  static OrderServiceGetDailyStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
}

class OrderServiceGetDailyStatsResponse extends $pb.GeneratedMessage {
  factory OrderServiceGetDailyStatsResponse({
    $core.int? orderCount,
    $1.Money? totalAmount,
  }) {
    final result = OrderServiceGetDailyStatsResponse._();
    if (orderCount != null) result.orderCount = orderCount;
    if (totalAmount != null) result.totalAmount = totalAmount;
    return result;
  }

  OrderServiceGetDailyStatsResponse._();

  factory OrderServiceGetDailyStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetDailyStatsResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceGetDailyStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetDailyStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetDailyStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetDailyStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'orderCount')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'totalAmount',
        subBuilder: $1.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetDailyStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetDailyStatsResponse copyWith(
          void Function(OrderServiceGetDailyStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OrderServiceGetDailyStatsResponse))
          as OrderServiceGetDailyStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetDailyStatsResponse() / OrderServiceGetDailyStatsResponse.new instead')
  static OrderServiceGetDailyStatsResponse create() =>
      OrderServiceGetDailyStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetDailyStatsResponse._();
  @$core.override
  OrderServiceGetDailyStatsResponse createEmptyInstance() =>
      OrderServiceGetDailyStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetDailyStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetDailyStatsResponse>(
          OrderServiceGetDailyStatsResponse.$_createMessage);
  static OrderServiceGetDailyStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get orderCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set orderCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Money get totalAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalAmount($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensureTotalAmount() => $_ensure(1);
}

class OrderServiceGetLabelRequest extends $pb.GeneratedMessage {
  factory OrderServiceGetLabelRequest({
    $core.String? orderId,
  }) {
    final result = OrderServiceGetLabelRequest._();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  OrderServiceGetLabelRequest._();

  factory OrderServiceGetLabelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetLabelRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceGetLabelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetLabelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetLabelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetLabelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetLabelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetLabelRequest copyWith(
          void Function(OrderServiceGetLabelRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceGetLabelRequest))
          as OrderServiceGetLabelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetLabelRequest() / OrderServiceGetLabelRequest.new instead')
  static OrderServiceGetLabelRequest create() =>
      OrderServiceGetLabelRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetLabelRequest._();
  @$core.override
  OrderServiceGetLabelRequest createEmptyInstance() =>
      OrderServiceGetLabelRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetLabelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetLabelRequest>(
          OrderServiceGetLabelRequest.$_createMessage);
  static OrderServiceGetLabelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
}

class OrderServiceGetLabelResponse extends $pb.GeneratedMessage {
  factory OrderServiceGetLabelResponse({
    $core.String? labelUrl,
    $core.String? trackingNumber,
    $core.String? carrier,
  }) {
    final result = OrderServiceGetLabelResponse._();
    if (labelUrl != null) result.labelUrl = labelUrl;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (carrier != null) result.carrier = carrier;
    return result;
  }

  OrderServiceGetLabelResponse._();

  factory OrderServiceGetLabelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetLabelResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceGetLabelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceGetLabelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceGetLabelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceGetLabelResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'labelUrl')
    ..aOS(2, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(3, _omitFieldNames ? '' : 'carrier')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetLabelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceGetLabelResponse copyWith(
          void Function(OrderServiceGetLabelResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceGetLabelResponse))
          as OrderServiceGetLabelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceGetLabelResponse() / OrderServiceGetLabelResponse.new instead')
  static OrderServiceGetLabelResponse create() =>
      OrderServiceGetLabelResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceGetLabelResponse._();
  @$core.override
  OrderServiceGetLabelResponse createEmptyInstance() =>
      OrderServiceGetLabelResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceGetLabelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceGetLabelResponse>(
          OrderServiceGetLabelResponse.$_createMessage);
  static OrderServiceGetLabelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get labelUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set labelUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLabelUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabelUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trackingNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackingNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackingNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackingNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get carrier => $_getSZ(2);
  @$pb.TagNumber(3)
  set carrier($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCarrier() => $_has(2);
  @$pb.TagNumber(3)
  void clearCarrier() => $_clearField(3);
}

class OrderServiceListRecentRequest extends $pb.GeneratedMessage {
  factory OrderServiceListRecentRequest({
    $core.int? limit,
  }) {
    final result = OrderServiceListRecentRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  OrderServiceListRecentRequest._();

  factory OrderServiceListRecentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRecentRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceListRecentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRecentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceListRecentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceListRecentRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRecentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRecentRequest copyWith(
          void Function(OrderServiceListRecentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceListRecentRequest))
          as OrderServiceListRecentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceListRecentRequest() / OrderServiceListRecentRequest.new instead')
  static OrderServiceListRecentRequest create() =>
      OrderServiceListRecentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceListRecentRequest._();
  @$core.override
  OrderServiceListRecentRequest createEmptyInstance() =>
      OrderServiceListRecentRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceListRecentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceListRecentRequest>(
          OrderServiceListRecentRequest.$_createMessage);
  static OrderServiceListRecentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class OrderServiceListRecentResponse extends $pb.GeneratedMessage {
  factory OrderServiceListRecentResponse({
    $core.Iterable<Order>? orders,
  }) {
    final result = OrderServiceListRecentResponse._();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  OrderServiceListRecentResponse._();

  factory OrderServiceListRecentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRecentResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceListRecentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceListRecentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceListRecentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceListRecentResponse.$_createMessage)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: Order.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRecentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceListRecentResponse copyWith(
          void Function(OrderServiceListRecentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceListRecentResponse))
          as OrderServiceListRecentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceListRecentResponse() / OrderServiceListRecentResponse.new instead')
  static OrderServiceListRecentResponse create() =>
      OrderServiceListRecentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceListRecentResponse._();
  @$core.override
  OrderServiceListRecentResponse createEmptyInstance() =>
      OrderServiceListRecentResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceListRecentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceListRecentResponse>(
          OrderServiceListRecentResponse.$_createMessage);
  static OrderServiceListRecentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);
}

class OrderServiceBulkCancelRequest extends $pb.GeneratedMessage {
  factory OrderServiceBulkCancelRequest({
    $1.CommandContext? context,
    $core.Iterable<$core.String>? orderIds,
    $core.String? reason,
  }) {
    final result = OrderServiceBulkCancelRequest._();
    if (context != null) result.context = context;
    if (orderIds != null) result.orderIds.addAll(orderIds);
    if (reason != null) result.reason = reason;
    return result;
  }

  OrderServiceBulkCancelRequest._();

  factory OrderServiceBulkCancelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkCancelRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceBulkCancelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkCancelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceBulkCancelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceBulkCancelRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'orderIds')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkCancelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkCancelRequest copyWith(
          void Function(OrderServiceBulkCancelRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceBulkCancelRequest))
          as OrderServiceBulkCancelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceBulkCancelRequest() / OrderServiceBulkCancelRequest.new instead')
  static OrderServiceBulkCancelRequest create() =>
      OrderServiceBulkCancelRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceBulkCancelRequest._();
  @$core.override
  OrderServiceBulkCancelRequest createEmptyInstance() =>
      OrderServiceBulkCancelRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceBulkCancelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceBulkCancelRequest>(
          OrderServiceBulkCancelRequest.$_createMessage);
  static OrderServiceBulkCancelRequest? _defaultInstance;

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
  $pb.PbList<$core.String> get orderIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class OrderServiceBulkCancelResponse extends $pb.GeneratedMessage {
  factory OrderServiceBulkCancelResponse({
    $core.int? cancelledCount,
    $core.Iterable<$core.String>? failedOrderIds,
  }) {
    final result = OrderServiceBulkCancelResponse._();
    if (cancelledCount != null) result.cancelledCount = cancelledCount;
    if (failedOrderIds != null) result.failedOrderIds.addAll(failedOrderIds);
    return result;
  }

  OrderServiceBulkCancelResponse._();

  factory OrderServiceBulkCancelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkCancelResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceBulkCancelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkCancelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceBulkCancelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceBulkCancelResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'cancelledCount')
    ..pPS(2, _omitFieldNames ? '' : 'failedOrderIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkCancelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkCancelResponse copyWith(
          void Function(OrderServiceBulkCancelResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrderServiceBulkCancelResponse))
          as OrderServiceBulkCancelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceBulkCancelResponse() / OrderServiceBulkCancelResponse.new instead')
  static OrderServiceBulkCancelResponse create() =>
      OrderServiceBulkCancelResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceBulkCancelResponse._();
  @$core.override
  OrderServiceBulkCancelResponse createEmptyInstance() =>
      OrderServiceBulkCancelResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceBulkCancelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderServiceBulkCancelResponse>(
          OrderServiceBulkCancelResponse.$_createMessage);
  static OrderServiceBulkCancelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cancelledCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set cancelledCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCancelledCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCancelledCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get failedOrderIds => $_getList(1);
}

class OrderServiceBulkUpdateStatusRequest extends $pb.GeneratedMessage {
  factory OrderServiceBulkUpdateStatusRequest({
    $1.CommandContext? context,
    $core.Iterable<$core.String>? orderIds,
    OrderLifecycleState? targetState,
  }) {
    final result = OrderServiceBulkUpdateStatusRequest._();
    if (context != null) result.context = context;
    if (orderIds != null) result.orderIds.addAll(orderIds);
    if (targetState != null) result.targetState = targetState;
    return result;
  }

  OrderServiceBulkUpdateStatusRequest._();

  factory OrderServiceBulkUpdateStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory OrderServiceBulkUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceBulkUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceBulkUpdateStatusRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'orderIds')
    ..aE<OrderLifecycleState>(3, _omitFieldNames ? '' : 'targetState',
        enumValues: OrderLifecycleState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkUpdateStatusRequest copyWith(
          void Function(OrderServiceBulkUpdateStatusRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OrderServiceBulkUpdateStatusRequest))
          as OrderServiceBulkUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceBulkUpdateStatusRequest() / OrderServiceBulkUpdateStatusRequest.new instead')
  static OrderServiceBulkUpdateStatusRequest create() =>
      OrderServiceBulkUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceBulkUpdateStatusRequest._();
  @$core.override
  OrderServiceBulkUpdateStatusRequest createEmptyInstance() =>
      OrderServiceBulkUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceBulkUpdateStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OrderServiceBulkUpdateStatusRequest>(
          OrderServiceBulkUpdateStatusRequest.$_createMessage);
  static OrderServiceBulkUpdateStatusRequest? _defaultInstance;

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
  $pb.PbList<$core.String> get orderIds => $_getList(1);

  @$pb.TagNumber(3)
  OrderLifecycleState get targetState => $_getN(2);
  @$pb.TagNumber(3)
  set targetState(OrderLifecycleState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetState() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetState() => $_clearField(3);
}

class OrderServiceBulkUpdateStatusResponse extends $pb.GeneratedMessage {
  factory OrderServiceBulkUpdateStatusResponse({
    $core.int? updatedCount,
    $core.Iterable<$core.String>? failedOrderIds,
  }) {
    final result = OrderServiceBulkUpdateStatusResponse._();
    if (updatedCount != null) result.updatedCount = updatedCount;
    if (failedOrderIds != null) result.failedOrderIds.addAll(failedOrderIds);
    return result;
  }

  OrderServiceBulkUpdateStatusResponse._();

  factory OrderServiceBulkUpdateStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory OrderServiceBulkUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderServiceBulkUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderServiceBulkUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderServiceBulkUpdateStatusResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'updatedCount')
    ..pPS(2, _omitFieldNames ? '' : 'failedOrderIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderServiceBulkUpdateStatusResponse copyWith(
          void Function(OrderServiceBulkUpdateStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OrderServiceBulkUpdateStatusResponse))
          as OrderServiceBulkUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OrderServiceBulkUpdateStatusResponse() / OrderServiceBulkUpdateStatusResponse.new instead')
  static OrderServiceBulkUpdateStatusResponse create() =>
      OrderServiceBulkUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OrderServiceBulkUpdateStatusResponse._();
  @$core.override
  OrderServiceBulkUpdateStatusResponse createEmptyInstance() =>
      OrderServiceBulkUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static OrderServiceBulkUpdateStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OrderServiceBulkUpdateStatusResponse>(
          OrderServiceBulkUpdateStatusResponse.$_createMessage);
  static OrderServiceBulkUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get updatedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set updatedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdatedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get failedOrderIds => $_getList(1);
}

class InventoryServiceGetSummaryRequest extends $pb.GeneratedMessage {
  factory InventoryServiceGetSummaryRequest() =>
      InventoryServiceGetSummaryRequest._();

  InventoryServiceGetSummaryRequest._();

  factory InventoryServiceGetSummaryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetSummaryRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceGetSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceGetSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceGetSummaryRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetSummaryRequest copyWith(
          void Function(InventoryServiceGetSummaryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceGetSummaryRequest))
          as InventoryServiceGetSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceGetSummaryRequest() / InventoryServiceGetSummaryRequest.new instead')
  static InventoryServiceGetSummaryRequest create() =>
      InventoryServiceGetSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceGetSummaryRequest._();
  @$core.override
  InventoryServiceGetSummaryRequest createEmptyInstance() =>
      InventoryServiceGetSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceGetSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceGetSummaryRequest>(
          InventoryServiceGetSummaryRequest.$_createMessage);
  static InventoryServiceGetSummaryRequest? _defaultInstance;
}

class InventoryServiceGetSummaryResponse extends $pb.GeneratedMessage {
  factory InventoryServiceGetSummaryResponse({
    $core.int? totalSkus,
    $core.int? totalOnHand,
    $core.int? totalReserved,
    $core.int? lowStockAlerts,
  }) {
    final result = InventoryServiceGetSummaryResponse._();
    if (totalSkus != null) result.totalSkus = totalSkus;
    if (totalOnHand != null) result.totalOnHand = totalOnHand;
    if (totalReserved != null) result.totalReserved = totalReserved;
    if (lowStockAlerts != null) result.lowStockAlerts = lowStockAlerts;
    return result;
  }

  InventoryServiceGetSummaryResponse._();

  factory InventoryServiceGetSummaryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetSummaryResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceGetSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceGetSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceGetSummaryResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalSkus')
    ..aI(2, _omitFieldNames ? '' : 'totalOnHand')
    ..aI(3, _omitFieldNames ? '' : 'totalReserved')
    ..aI(4, _omitFieldNames ? '' : 'lowStockAlerts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetSummaryResponse copyWith(
          void Function(InventoryServiceGetSummaryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceGetSummaryResponse))
          as InventoryServiceGetSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceGetSummaryResponse() / InventoryServiceGetSummaryResponse.new instead')
  static InventoryServiceGetSummaryResponse create() =>
      InventoryServiceGetSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceGetSummaryResponse._();
  @$core.override
  InventoryServiceGetSummaryResponse createEmptyInstance() =>
      InventoryServiceGetSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceGetSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceGetSummaryResponse>(
          InventoryServiceGetSummaryResponse.$_createMessage);
  static InventoryServiceGetSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalSkus => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalSkus($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalSkus() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalSkus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalOnHand => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalOnHand($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalOnHand() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalOnHand() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalReserved => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalReserved($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalReserved() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalReserved() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get lowStockAlerts => $_getIZ(3);
  @$pb.TagNumber(4)
  set lowStockAlerts($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLowStockAlerts() => $_has(3);
  @$pb.TagNumber(4)
  void clearLowStockAlerts() => $_clearField(4);
}

class InventoryServiceListStockRequest extends $pb.GeneratedMessage {
  factory InventoryServiceListStockRequest({
    $core.String? locationId,
    $1.Pagination? pagination,
  }) {
    final result = InventoryServiceListStockRequest._();
    if (locationId != null) result.locationId = locationId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  InventoryServiceListStockRequest._();

  factory InventoryServiceListStockRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListStockRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceListStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListStockRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceListStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceListStockRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListStockRequest copyWith(
          void Function(InventoryServiceListStockRequest) updates) =>
      super.copyWith(
              (message) => updates(message as InventoryServiceListStockRequest))
          as InventoryServiceListStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceListStockRequest() / InventoryServiceListStockRequest.new instead')
  static InventoryServiceListStockRequest create() =>
      InventoryServiceListStockRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceListStockRequest._();
  @$core.override
  InventoryServiceListStockRequest createEmptyInstance() =>
      InventoryServiceListStockRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceListStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceListStockRequest>(
          InventoryServiceListStockRequest.$_createMessage);
  static InventoryServiceListStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

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

class InventoryServiceListStockResponse extends $pb.GeneratedMessage {
  factory InventoryServiceListStockResponse({
    $core.Iterable<InventoryBalance>? items,
    $1.PaginatedResponse? pagination,
  }) {
    final result = InventoryServiceListStockResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  InventoryServiceListStockResponse._();

  factory InventoryServiceListStockResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListStockResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceListStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListStockResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceListStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceListStockResponse.$_createMessage)
    ..pPM<InventoryBalance>(1, _omitFieldNames ? '' : 'items',
        subBuilder: InventoryBalance.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListStockResponse copyWith(
          void Function(InventoryServiceListStockResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceListStockResponse))
          as InventoryServiceListStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceListStockResponse() / InventoryServiceListStockResponse.new instead')
  static InventoryServiceListStockResponse create() =>
      InventoryServiceListStockResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceListStockResponse._();
  @$core.override
  InventoryServiceListStockResponse createEmptyInstance() =>
      InventoryServiceListStockResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceListStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceListStockResponse>(
          InventoryServiceListStockResponse.$_createMessage);
  static InventoryServiceListStockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InventoryBalance> get items => $_getList(0);

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

class InventoryServiceListMovementsRequest extends $pb.GeneratedMessage {
  factory InventoryServiceListMovementsRequest({
    $core.String? skuId,
    $core.String? locationId,
    $1.Pagination? pagination,
  }) {
    final result = InventoryServiceListMovementsRequest._();
    if (skuId != null) result.skuId = skuId;
    if (locationId != null) result.locationId = locationId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  InventoryServiceListMovementsRequest._();

  factory InventoryServiceListMovementsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListMovementsRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceListMovementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListMovementsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceListMovementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceListMovementsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOM<$1.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListMovementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListMovementsRequest copyWith(
          void Function(InventoryServiceListMovementsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceListMovementsRequest))
          as InventoryServiceListMovementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceListMovementsRequest() / InventoryServiceListMovementsRequest.new instead')
  static InventoryServiceListMovementsRequest create() =>
      InventoryServiceListMovementsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceListMovementsRequest._();
  @$core.override
  InventoryServiceListMovementsRequest createEmptyInstance() =>
      InventoryServiceListMovementsRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceListMovementsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceListMovementsRequest>(
          InventoryServiceListMovementsRequest.$_createMessage);
  static InventoryServiceListMovementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Pagination ensurePagination() => $_ensure(2);
}

class InventoryServiceListMovementsResponse extends $pb.GeneratedMessage {
  factory InventoryServiceListMovementsResponse({
    $core.Iterable<StockMovement>? movements,
    $1.PaginatedResponse? pagination,
  }) {
    final result = InventoryServiceListMovementsResponse._();
    if (movements != null) result.movements.addAll(movements);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  InventoryServiceListMovementsResponse._();

  factory InventoryServiceListMovementsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListMovementsResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceListMovementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceListMovementsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceListMovementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          InventoryServiceListMovementsResponse.$_createMessage)
    ..pPM<StockMovement>(1, _omitFieldNames ? '' : 'movements',
        subBuilder: StockMovement.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListMovementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceListMovementsResponse copyWith(
          void Function(InventoryServiceListMovementsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceListMovementsResponse))
          as InventoryServiceListMovementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceListMovementsResponse() / InventoryServiceListMovementsResponse.new instead')
  static InventoryServiceListMovementsResponse create() =>
      InventoryServiceListMovementsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceListMovementsResponse._();
  @$core.override
  InventoryServiceListMovementsResponse createEmptyInstance() =>
      InventoryServiceListMovementsResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceListMovementsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceListMovementsResponse>(
          InventoryServiceListMovementsResponse.$_createMessage);
  static InventoryServiceListMovementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StockMovement> get movements => $_getList(0);

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

class InventoryServiceCreateStockMovementRequest extends $pb.GeneratedMessage {
  factory InventoryServiceCreateStockMovementRequest({
    $1.CommandContext? context,
    $core.String? skuId,
    $core.String? locationId,
    StockMovementType? movementType,
    $core.int? quantity,
    $core.String? reason,
    $core.String? referenceType,
    $core.String? referenceId,
  }) {
    final result = InventoryServiceCreateStockMovementRequest._();
    if (context != null) result.context = context;
    if (skuId != null) result.skuId = skuId;
    if (locationId != null) result.locationId = locationId;
    if (movementType != null) result.movementType = movementType;
    if (quantity != null) result.quantity = quantity;
    if (reason != null) result.reason = reason;
    if (referenceType != null) result.referenceType = referenceType;
    if (referenceId != null) result.referenceId = referenceId;
    return result;
  }

  InventoryServiceCreateStockMovementRequest._();

  factory InventoryServiceCreateStockMovementRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceCreateStockMovementRequest()
        ..mergeFromBuffer(data, registry);
  factory InventoryServiceCreateStockMovementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceCreateStockMovementRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceCreateStockMovementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          InventoryServiceCreateStockMovementRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'skuId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aE<StockMovementType>(4, _omitFieldNames ? '' : 'movementType',
        enumValues: StockMovementType.values)
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'referenceType')
    ..aOS(8, _omitFieldNames ? '' : 'referenceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceCreateStockMovementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceCreateStockMovementRequest copyWith(
          void Function(InventoryServiceCreateStockMovementRequest) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceCreateStockMovementRequest))
          as InventoryServiceCreateStockMovementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceCreateStockMovementRequest() / InventoryServiceCreateStockMovementRequest.new instead')
  static InventoryServiceCreateStockMovementRequest create() =>
      InventoryServiceCreateStockMovementRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceCreateStockMovementRequest._();
  @$core.override
  InventoryServiceCreateStockMovementRequest createEmptyInstance() =>
      InventoryServiceCreateStockMovementRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceCreateStockMovementRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceCreateStockMovementRequest>(
          InventoryServiceCreateStockMovementRequest.$_createMessage);
  static InventoryServiceCreateStockMovementRequest? _defaultInstance;

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
  $core.String get skuId => $_getSZ(1);
  @$pb.TagNumber(2)
  set skuId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSkuId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkuId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  StockMovementType get movementType => $_getN(3);
  @$pb.TagNumber(4)
  set movementType(StockMovementType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMovementType() => $_has(3);
  @$pb.TagNumber(4)
  void clearMovementType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get referenceType => $_getSZ(6);
  @$pb.TagNumber(7)
  set referenceType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReferenceType() => $_has(6);
  @$pb.TagNumber(7)
  void clearReferenceType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get referenceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set referenceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReferenceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferenceId() => $_clearField(8);
}

class InventoryServiceCreateStockMovementResponse extends $pb.GeneratedMessage {
  factory InventoryServiceCreateStockMovementResponse({
    StockMovement? movement,
    InventoryBalance? newBalance,
  }) {
    final result = InventoryServiceCreateStockMovementResponse._();
    if (movement != null) result.movement = movement;
    if (newBalance != null) result.newBalance = newBalance;
    return result;
  }

  InventoryServiceCreateStockMovementResponse._();

  factory InventoryServiceCreateStockMovementResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceCreateStockMovementResponse()
        ..mergeFromBuffer(data, registry);
  factory InventoryServiceCreateStockMovementResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceCreateStockMovementResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceCreateStockMovementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          InventoryServiceCreateStockMovementResponse.$_createMessage)
    ..aOM<StockMovement>(1, _omitFieldNames ? '' : 'movement',
        subBuilder: StockMovement.$_createMessage)
    ..aOM<InventoryBalance>(2, _omitFieldNames ? '' : 'newBalance',
        subBuilder: InventoryBalance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceCreateStockMovementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceCreateStockMovementResponse copyWith(
          void Function(InventoryServiceCreateStockMovementResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceCreateStockMovementResponse))
          as InventoryServiceCreateStockMovementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceCreateStockMovementResponse() / InventoryServiceCreateStockMovementResponse.new instead')
  static InventoryServiceCreateStockMovementResponse create() =>
      InventoryServiceCreateStockMovementResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceCreateStockMovementResponse._();
  @$core.override
  InventoryServiceCreateStockMovementResponse createEmptyInstance() =>
      InventoryServiceCreateStockMovementResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceCreateStockMovementResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceCreateStockMovementResponse>(
          InventoryServiceCreateStockMovementResponse.$_createMessage);
  static InventoryServiceCreateStockMovementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StockMovement get movement => $_getN(0);
  @$pb.TagNumber(1)
  set movement(StockMovement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMovement() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovement() => $_clearField(1);
  @$pb.TagNumber(1)
  StockMovement ensureMovement() => $_ensure(0);

  @$pb.TagNumber(2)
  InventoryBalance get newBalance => $_getN(1);
  @$pb.TagNumber(2)
  set newBalance(InventoryBalance value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNewBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewBalance() => $_clearField(2);
  @$pb.TagNumber(2)
  InventoryBalance ensureNewBalance() => $_ensure(1);
}

class InventoryServiceBulkStockInRequest extends $pb.GeneratedMessage {
  factory InventoryServiceBulkStockInRequest({
    $1.CommandContext? context,
    $core.String? locationId,
    $core.Iterable<StockMovementItem>? items,
    $core.String? reason,
  }) {
    final result = InventoryServiceBulkStockInRequest._();
    if (context != null) result.context = context;
    if (locationId != null) result.locationId = locationId;
    if (items != null) result.items.addAll(items);
    if (reason != null) result.reason = reason;
    return result;
  }

  InventoryServiceBulkStockInRequest._();

  factory InventoryServiceBulkStockInRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceBulkStockInRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceBulkStockInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceBulkStockInRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceBulkStockInRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceBulkStockInRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..pPM<StockMovementItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: StockMovementItem.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceBulkStockInRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceBulkStockInRequest copyWith(
          void Function(InventoryServiceBulkStockInRequest) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceBulkStockInRequest))
          as InventoryServiceBulkStockInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceBulkStockInRequest() / InventoryServiceBulkStockInRequest.new instead')
  static InventoryServiceBulkStockInRequest create() =>
      InventoryServiceBulkStockInRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceBulkStockInRequest._();
  @$core.override
  InventoryServiceBulkStockInRequest createEmptyInstance() =>
      InventoryServiceBulkStockInRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceBulkStockInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceBulkStockInRequest>(
          InventoryServiceBulkStockInRequest.$_createMessage);
  static InventoryServiceBulkStockInRequest? _defaultInstance;

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
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<StockMovementItem> get items => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class InventoryServiceBulkStockInResponse extends $pb.GeneratedMessage {
  factory InventoryServiceBulkStockInResponse({
    $core.int? processedCount,
    $core.Iterable<StockMovement>? movements,
  }) {
    final result = InventoryServiceBulkStockInResponse._();
    if (processedCount != null) result.processedCount = processedCount;
    if (movements != null) result.movements.addAll(movements);
    return result;
  }

  InventoryServiceBulkStockInResponse._();

  factory InventoryServiceBulkStockInResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceBulkStockInResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceBulkStockInResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceBulkStockInResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceBulkStockInResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceBulkStockInResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'processedCount')
    ..pPM<StockMovement>(2, _omitFieldNames ? '' : 'movements',
        subBuilder: StockMovement.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceBulkStockInResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceBulkStockInResponse copyWith(
          void Function(InventoryServiceBulkStockInResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceBulkStockInResponse))
          as InventoryServiceBulkStockInResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceBulkStockInResponse() / InventoryServiceBulkStockInResponse.new instead')
  static InventoryServiceBulkStockInResponse create() =>
      InventoryServiceBulkStockInResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceBulkStockInResponse._();
  @$core.override
  InventoryServiceBulkStockInResponse createEmptyInstance() =>
      InventoryServiceBulkStockInResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceBulkStockInResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceBulkStockInResponse>(
          InventoryServiceBulkStockInResponse.$_createMessage);
  static InventoryServiceBulkStockInResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get processedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set processedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcessedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<StockMovement> get movements => $_getList(1);
}

class InventoryServiceGetAlertsRequest extends $pb.GeneratedMessage {
  factory InventoryServiceGetAlertsRequest() =>
      InventoryServiceGetAlertsRequest._();

  InventoryServiceGetAlertsRequest._();

  factory InventoryServiceGetAlertsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetAlertsRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceGetAlertsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetAlertsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceGetAlertsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceGetAlertsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetAlertsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetAlertsRequest copyWith(
          void Function(InventoryServiceGetAlertsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as InventoryServiceGetAlertsRequest))
          as InventoryServiceGetAlertsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceGetAlertsRequest() / InventoryServiceGetAlertsRequest.new instead')
  static InventoryServiceGetAlertsRequest create() =>
      InventoryServiceGetAlertsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceGetAlertsRequest._();
  @$core.override
  InventoryServiceGetAlertsRequest createEmptyInstance() =>
      InventoryServiceGetAlertsRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceGetAlertsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceGetAlertsRequest>(
          InventoryServiceGetAlertsRequest.$_createMessage);
  static InventoryServiceGetAlertsRequest? _defaultInstance;
}

class InventoryServiceGetAlertsResponse extends $pb.GeneratedMessage {
  factory InventoryServiceGetAlertsResponse({
    $core.Iterable<InventoryAlert>? alerts,
  }) {
    final result = InventoryServiceGetAlertsResponse._();
    if (alerts != null) result.alerts.addAll(alerts);
    return result;
  }

  InventoryServiceGetAlertsResponse._();

  factory InventoryServiceGetAlertsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetAlertsResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceGetAlertsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceGetAlertsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceGetAlertsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceGetAlertsResponse.$_createMessage)
    ..pPM<InventoryAlert>(1, _omitFieldNames ? '' : 'alerts',
        subBuilder: InventoryAlert.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetAlertsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceGetAlertsResponse copyWith(
          void Function(InventoryServiceGetAlertsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceGetAlertsResponse))
          as InventoryServiceGetAlertsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceGetAlertsResponse() / InventoryServiceGetAlertsResponse.new instead')
  static InventoryServiceGetAlertsResponse create() =>
      InventoryServiceGetAlertsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceGetAlertsResponse._();
  @$core.override
  InventoryServiceGetAlertsResponse createEmptyInstance() =>
      InventoryServiceGetAlertsResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceGetAlertsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceGetAlertsResponse>(
          InventoryServiceGetAlertsResponse.$_createMessage);
  static InventoryServiceGetAlertsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InventoryAlert> get alerts => $_getList(0);
}

class InventoryServiceUpdateThresholdsRequest extends $pb.GeneratedMessage {
  factory InventoryServiceUpdateThresholdsRequest({
    $1.CommandContext? context,
    $core.String? skuId,
    $core.int? lowStockThreshold,
  }) {
    final result = InventoryServiceUpdateThresholdsRequest._();
    if (context != null) result.context = context;
    if (skuId != null) result.skuId = skuId;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    return result;
  }

  InventoryServiceUpdateThresholdsRequest._();

  factory InventoryServiceUpdateThresholdsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceUpdateThresholdsRequest()
        ..mergeFromBuffer(data, registry);
  factory InventoryServiceUpdateThresholdsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceUpdateThresholdsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceUpdateThresholdsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          InventoryServiceUpdateThresholdsRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'skuId')
    ..aI(3, _omitFieldNames ? '' : 'lowStockThreshold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceUpdateThresholdsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceUpdateThresholdsRequest copyWith(
          void Function(InventoryServiceUpdateThresholdsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceUpdateThresholdsRequest))
          as InventoryServiceUpdateThresholdsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceUpdateThresholdsRequest() / InventoryServiceUpdateThresholdsRequest.new instead')
  static InventoryServiceUpdateThresholdsRequest create() =>
      InventoryServiceUpdateThresholdsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceUpdateThresholdsRequest._();
  @$core.override
  InventoryServiceUpdateThresholdsRequest createEmptyInstance() =>
      InventoryServiceUpdateThresholdsRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceUpdateThresholdsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceUpdateThresholdsRequest>(
          InventoryServiceUpdateThresholdsRequest.$_createMessage);
  static InventoryServiceUpdateThresholdsRequest? _defaultInstance;

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
  $core.String get skuId => $_getSZ(1);
  @$pb.TagNumber(2)
  set skuId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSkuId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkuId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get lowStockThreshold => $_getIZ(2);
  @$pb.TagNumber(3)
  set lowStockThreshold($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLowStockThreshold() => $_has(2);
  @$pb.TagNumber(3)
  void clearLowStockThreshold() => $_clearField(3);
}

class InventoryServiceUpdateThresholdsResponse extends $pb.GeneratedMessage {
  factory InventoryServiceUpdateThresholdsResponse({
    $core.String? skuId,
    $core.int? lowStockThreshold,
  }) {
    final result = InventoryServiceUpdateThresholdsResponse._();
    if (skuId != null) result.skuId = skuId;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    return result;
  }

  InventoryServiceUpdateThresholdsResponse._();

  factory InventoryServiceUpdateThresholdsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceUpdateThresholdsResponse()
        ..mergeFromBuffer(data, registry);
  factory InventoryServiceUpdateThresholdsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceUpdateThresholdsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceUpdateThresholdsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          InventoryServiceUpdateThresholdsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skuId')
    ..aI(2, _omitFieldNames ? '' : 'lowStockThreshold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceUpdateThresholdsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceUpdateThresholdsResponse copyWith(
          void Function(InventoryServiceUpdateThresholdsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as InventoryServiceUpdateThresholdsResponse))
          as InventoryServiceUpdateThresholdsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceUpdateThresholdsResponse() / InventoryServiceUpdateThresholdsResponse.new instead')
  static InventoryServiceUpdateThresholdsResponse create() =>
      InventoryServiceUpdateThresholdsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceUpdateThresholdsResponse._();
  @$core.override
  InventoryServiceUpdateThresholdsResponse createEmptyInstance() =>
      InventoryServiceUpdateThresholdsResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceUpdateThresholdsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              InventoryServiceUpdateThresholdsResponse>(
          InventoryServiceUpdateThresholdsResponse.$_createMessage);
  static InventoryServiceUpdateThresholdsResponse? _defaultInstance;

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

class InventoryServiceExportRequest extends $pb.GeneratedMessage {
  factory InventoryServiceExportRequest({
    $core.String? locationId,
    $core.String? format,
  }) {
    final result = InventoryServiceExportRequest._();
    if (locationId != null) result.locationId = locationId;
    if (format != null) result.format = format;
    return result;
  }

  InventoryServiceExportRequest._();

  factory InventoryServiceExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceExportRequest()..mergeFromBuffer(data, registry);
  factory InventoryServiceExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceExportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceExportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceExportRequest copyWith(
          void Function(InventoryServiceExportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as InventoryServiceExportRequest))
          as InventoryServiceExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceExportRequest() / InventoryServiceExportRequest.new instead')
  static InventoryServiceExportRequest create() =>
      InventoryServiceExportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceExportRequest._();
  @$core.override
  InventoryServiceExportRequest createEmptyInstance() =>
      InventoryServiceExportRequest._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceExportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceExportRequest>(
          InventoryServiceExportRequest.$_createMessage);
  static InventoryServiceExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);
}

class InventoryServiceExportResponse extends $pb.GeneratedMessage {
  factory InventoryServiceExportResponse({
    $core.String? downloadUrl,
    $core.int? rowCount,
  }) {
    final result = InventoryServiceExportResponse._();
    if (downloadUrl != null) result.downloadUrl = downloadUrl;
    if (rowCount != null) result.rowCount = rowCount;
    return result;
  }

  InventoryServiceExportResponse._();

  factory InventoryServiceExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceExportResponse()..mergeFromBuffer(data, registry);
  factory InventoryServiceExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryServiceExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryServiceExportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: InventoryServiceExportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'downloadUrl')
    ..aI(2, _omitFieldNames ? '' : 'rowCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryServiceExportResponse copyWith(
          void Function(InventoryServiceExportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as InventoryServiceExportResponse))
          as InventoryServiceExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InventoryServiceExportResponse() / InventoryServiceExportResponse.new instead')
  static InventoryServiceExportResponse create() =>
      InventoryServiceExportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InventoryServiceExportResponse._();
  @$core.override
  InventoryServiceExportResponse createEmptyInstance() =>
      InventoryServiceExportResponse._();
  @$core.pragma('dart2js:noInline')
  static InventoryServiceExportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InventoryServiceExportResponse>(
          InventoryServiceExportResponse.$_createMessage);
  static InventoryServiceExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get downloadUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set downloadUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDownloadUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearDownloadUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rowCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set rowCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRowCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRowCount() => $_clearField(2);
}

class RefundServiceCreateRequest extends $pb.GeneratedMessage {
  factory RefundServiceCreateRequest({
    $1.CommandContext? context,
    $core.String? orderId,
    $1.Money? amount,
    $core.String? reason,
    $core.String? refundType,
  }) {
    final result = RefundServiceCreateRequest._();
    if (context != null) result.context = context;
    if (orderId != null) result.orderId = orderId;
    if (amount != null) result.amount = amount;
    if (reason != null) result.reason = reason;
    if (refundType != null) result.refundType = refundType;
    return result;
  }

  RefundServiceCreateRequest._();

  factory RefundServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceCreateRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'refundType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceCreateRequest copyWith(
          void Function(RefundServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceCreateRequest))
          as RefundServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceCreateRequest() / RefundServiceCreateRequest.new instead')
  static RefundServiceCreateRequest create() => RefundServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceCreateRequest._();
  @$core.override
  RefundServiceCreateRequest createEmptyInstance() =>
      RefundServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceCreateRequest>(
          RefundServiceCreateRequest.$_createMessage);
  static RefundServiceCreateRequest? _defaultInstance;

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
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get refundType => $_getSZ(4);
  @$pb.TagNumber(5)
  set refundType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefundType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefundType() => $_clearField(5);
}

class RefundServiceCreateResponse extends $pb.GeneratedMessage {
  factory RefundServiceCreateResponse({
    Refund? refund,
    Order? updatedOrder,
  }) {
    final result = RefundServiceCreateResponse._();
    if (refund != null) result.refund = refund;
    if (updatedOrder != null) result.updatedOrder = updatedOrder;
    return result;
  }

  RefundServiceCreateResponse._();

  factory RefundServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceCreateResponse.$_createMessage)
    ..aOM<Refund>(1, _omitFieldNames ? '' : 'refund',
        subBuilder: Refund.$_createMessage)
    ..aOM<Order>(2, _omitFieldNames ? '' : 'updatedOrder',
        subBuilder: Order.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceCreateResponse copyWith(
          void Function(RefundServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceCreateResponse))
          as RefundServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceCreateResponse() / RefundServiceCreateResponse.new instead')
  static RefundServiceCreateResponse create() =>
      RefundServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceCreateResponse._();
  @$core.override
  RefundServiceCreateResponse createEmptyInstance() =>
      RefundServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceCreateResponse>(
          RefundServiceCreateResponse.$_createMessage);
  static RefundServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Refund get refund => $_getN(0);
  @$pb.TagNumber(1)
  set refund(Refund value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefund() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefund() => $_clearField(1);
  @$pb.TagNumber(1)
  Refund ensureRefund() => $_ensure(0);

  @$pb.TagNumber(2)
  Order get updatedOrder => $_getN(1);
  @$pb.TagNumber(2)
  set updatedOrder(Order value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdatedOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  Order ensureUpdatedOrder() => $_ensure(1);
}

class RefundServiceGetRequest extends $pb.GeneratedMessage {
  factory RefundServiceGetRequest({
    $core.String? refundId,
  }) {
    final result = RefundServiceGetRequest._();
    if (refundId != null) result.refundId = refundId;
    return result;
  }

  RefundServiceGetRequest._();

  factory RefundServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'refundId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetRequest copyWith(
          void Function(RefundServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as RefundServiceGetRequest))
          as RefundServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceGetRequest() / RefundServiceGetRequest.new instead')
  static RefundServiceGetRequest create() => RefundServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => RefundServiceGetRequest._();
  @$core.override
  RefundServiceGetRequest createEmptyInstance() => RefundServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceGetRequest>(
          RefundServiceGetRequest.$_createMessage);
  static RefundServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refundId => $_getSZ(0);
  @$pb.TagNumber(1)
  set refundId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefundId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefundId() => $_clearField(1);
}

class RefundServiceGetResponse extends $pb.GeneratedMessage {
  factory RefundServiceGetResponse({
    Refund? refund,
  }) {
    final result = RefundServiceGetResponse._();
    if (refund != null) result.refund = refund;
    return result;
  }

  RefundServiceGetResponse._();

  factory RefundServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceGetResponse.$_createMessage)
    ..aOM<Refund>(1, _omitFieldNames ? '' : 'refund',
        subBuilder: Refund.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetResponse copyWith(
          void Function(RefundServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as RefundServiceGetResponse))
          as RefundServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceGetResponse() / RefundServiceGetResponse.new instead')
  static RefundServiceGetResponse create() => RefundServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => RefundServiceGetResponse._();
  @$core.override
  RefundServiceGetResponse createEmptyInstance() =>
      RefundServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceGetResponse>(
          RefundServiceGetResponse.$_createMessage);
  static RefundServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Refund get refund => $_getN(0);
  @$pb.TagNumber(1)
  set refund(Refund value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefund() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefund() => $_clearField(1);
  @$pb.TagNumber(1)
  Refund ensureRefund() => $_ensure(0);
}

class RefundServiceListRequest extends $pb.GeneratedMessage {
  factory RefundServiceListRequest({
    $core.String? orderId,
    RefundLifecycleState? state,
    $1.Pagination? pagination,
  }) {
    final result = RefundServiceListRequest._();
    if (orderId != null) result.orderId = orderId;
    if (state != null) result.state = state;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  RefundServiceListRequest._();

  factory RefundServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceListRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aE<RefundLifecycleState>(2, _omitFieldNames ? '' : 'state',
        enumValues: RefundLifecycleState.values)
    ..aOM<$1.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceListRequest copyWith(
          void Function(RefundServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as RefundServiceListRequest))
          as RefundServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceListRequest() / RefundServiceListRequest.new instead')
  static RefundServiceListRequest create() => RefundServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => RefundServiceListRequest._();
  @$core.override
  RefundServiceListRequest createEmptyInstance() =>
      RefundServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceListRequest>(
          RefundServiceListRequest.$_createMessage);
  static RefundServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  RefundLifecycleState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(RefundLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Pagination ensurePagination() => $_ensure(2);
}

class RefundServiceListResponse extends $pb.GeneratedMessage {
  factory RefundServiceListResponse({
    $core.Iterable<Refund>? refunds,
    $1.PaginatedResponse? pagination,
  }) {
    final result = RefundServiceListResponse._();
    if (refunds != null) result.refunds.addAll(refunds);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  RefundServiceListResponse._();

  factory RefundServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceListResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceListResponse.$_createMessage)
    ..pPM<Refund>(1, _omitFieldNames ? '' : 'refunds',
        subBuilder: Refund.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceListResponse copyWith(
          void Function(RefundServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as RefundServiceListResponse))
          as RefundServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceListResponse() / RefundServiceListResponse.new instead')
  static RefundServiceListResponse create() => RefundServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceListResponse._();
  @$core.override
  RefundServiceListResponse createEmptyInstance() =>
      RefundServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceListResponse>(
          RefundServiceListResponse.$_createMessage);
  static RefundServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Refund> get refunds => $_getList(0);

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

class RefundServiceApproveRequest extends $pb.GeneratedMessage {
  factory RefundServiceApproveRequest({
    $1.CommandContext? context,
    $core.String? refundId,
    $core.String? reason,
  }) {
    final result = RefundServiceApproveRequest._();
    if (context != null) result.context = context;
    if (refundId != null) result.refundId = refundId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RefundServiceApproveRequest._();

  factory RefundServiceApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceApproveRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceApproveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceApproveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceApproveRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'refundId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceApproveRequest copyWith(
          void Function(RefundServiceApproveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceApproveRequest))
          as RefundServiceApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceApproveRequest() / RefundServiceApproveRequest.new instead')
  static RefundServiceApproveRequest create() =>
      RefundServiceApproveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceApproveRequest._();
  @$core.override
  RefundServiceApproveRequest createEmptyInstance() =>
      RefundServiceApproveRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceApproveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceApproveRequest>(
          RefundServiceApproveRequest.$_createMessage);
  static RefundServiceApproveRequest? _defaultInstance;

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
  $core.String get refundId => $_getSZ(1);
  @$pb.TagNumber(2)
  set refundId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefundId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefundId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RefundServiceApproveResponse extends $pb.GeneratedMessage {
  factory RefundServiceApproveResponse({
    Refund? refund,
    Order? updatedOrder,
  }) {
    final result = RefundServiceApproveResponse._();
    if (refund != null) result.refund = refund;
    if (updatedOrder != null) result.updatedOrder = updatedOrder;
    return result;
  }

  RefundServiceApproveResponse._();

  factory RefundServiceApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceApproveResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceApproveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceApproveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceApproveResponse.$_createMessage)
    ..aOM<Refund>(1, _omitFieldNames ? '' : 'refund',
        subBuilder: Refund.$_createMessage)
    ..aOM<Order>(2, _omitFieldNames ? '' : 'updatedOrder',
        subBuilder: Order.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceApproveResponse copyWith(
          void Function(RefundServiceApproveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceApproveResponse))
          as RefundServiceApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceApproveResponse() / RefundServiceApproveResponse.new instead')
  static RefundServiceApproveResponse create() =>
      RefundServiceApproveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceApproveResponse._();
  @$core.override
  RefundServiceApproveResponse createEmptyInstance() =>
      RefundServiceApproveResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceApproveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceApproveResponse>(
          RefundServiceApproveResponse.$_createMessage);
  static RefundServiceApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Refund get refund => $_getN(0);
  @$pb.TagNumber(1)
  set refund(Refund value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefund() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefund() => $_clearField(1);
  @$pb.TagNumber(1)
  Refund ensureRefund() => $_ensure(0);

  @$pb.TagNumber(2)
  Order get updatedOrder => $_getN(1);
  @$pb.TagNumber(2)
  set updatedOrder(Order value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdatedOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  Order ensureUpdatedOrder() => $_ensure(1);
}

class RefundServiceRejectRequest extends $pb.GeneratedMessage {
  factory RefundServiceRejectRequest({
    $1.CommandContext? context,
    $core.String? refundId,
    $core.String? reason,
  }) {
    final result = RefundServiceRejectRequest._();
    if (context != null) result.context = context;
    if (refundId != null) result.refundId = refundId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RefundServiceRejectRequest._();

  factory RefundServiceRejectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceRejectRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceRejectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceRejectRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceRejectRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceRejectRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'refundId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceRejectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceRejectRequest copyWith(
          void Function(RefundServiceRejectRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceRejectRequest))
          as RefundServiceRejectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceRejectRequest() / RefundServiceRejectRequest.new instead')
  static RefundServiceRejectRequest create() => RefundServiceRejectRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceRejectRequest._();
  @$core.override
  RefundServiceRejectRequest createEmptyInstance() =>
      RefundServiceRejectRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceRejectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceRejectRequest>(
          RefundServiceRejectRequest.$_createMessage);
  static RefundServiceRejectRequest? _defaultInstance;

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
  $core.String get refundId => $_getSZ(1);
  @$pb.TagNumber(2)
  set refundId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefundId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefundId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RefundServiceRejectResponse extends $pb.GeneratedMessage {
  factory RefundServiceRejectResponse({
    Refund? refund,
  }) {
    final result = RefundServiceRejectResponse._();
    if (refund != null) result.refund = refund;
    return result;
  }

  RefundServiceRejectResponse._();

  factory RefundServiceRejectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceRejectResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceRejectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceRejectResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceRejectResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceRejectResponse.$_createMessage)
    ..aOM<Refund>(1, _omitFieldNames ? '' : 'refund',
        subBuilder: Refund.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceRejectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceRejectResponse copyWith(
          void Function(RefundServiceRejectResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceRejectResponse))
          as RefundServiceRejectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceRejectResponse() / RefundServiceRejectResponse.new instead')
  static RefundServiceRejectResponse create() =>
      RefundServiceRejectResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceRejectResponse._();
  @$core.override
  RefundServiceRejectResponse createEmptyInstance() =>
      RefundServiceRejectResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceRejectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceRejectResponse>(
          RefundServiceRejectResponse.$_createMessage);
  static RefundServiceRejectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Refund get refund => $_getN(0);
  @$pb.TagNumber(1)
  set refund(Refund value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefund() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefund() => $_clearField(1);
  @$pb.TagNumber(1)
  Refund ensureRefund() => $_ensure(0);
}

class RefundServiceGetStatsRequest extends $pb.GeneratedMessage {
  factory RefundServiceGetStatsRequest() => RefundServiceGetStatsRequest._();

  RefundServiceGetStatsRequest._();

  factory RefundServiceGetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetStatsRequest()..mergeFromBuffer(data, registry);
  factory RefundServiceGetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceGetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceGetStatsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetStatsRequest copyWith(
          void Function(RefundServiceGetStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceGetStatsRequest))
          as RefundServiceGetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceGetStatsRequest() / RefundServiceGetStatsRequest.new instead')
  static RefundServiceGetStatsRequest create() =>
      RefundServiceGetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceGetStatsRequest._();
  @$core.override
  RefundServiceGetStatsRequest createEmptyInstance() =>
      RefundServiceGetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceGetStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceGetStatsRequest>(
          RefundServiceGetStatsRequest.$_createMessage);
  static RefundServiceGetStatsRequest? _defaultInstance;
}

class RefundServiceGetStatsResponse extends $pb.GeneratedMessage {
  factory RefundServiceGetStatsResponse({
    $core.int? totalRefunds,
    $1.Money? totalRefundedAmount,
    $core.int? pendingApprovalCount,
  }) {
    final result = RefundServiceGetStatsResponse._();
    if (totalRefunds != null) result.totalRefunds = totalRefunds;
    if (totalRefundedAmount != null)
      result.totalRefundedAmount = totalRefundedAmount;
    if (pendingApprovalCount != null)
      result.pendingApprovalCount = pendingApprovalCount;
    return result;
  }

  RefundServiceGetStatsResponse._();

  factory RefundServiceGetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetStatsResponse()..mergeFromBuffer(data, registry);
  factory RefundServiceGetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RefundServiceGetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundServiceGetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RefundServiceGetStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalRefunds')
    ..aOM<$1.Money>(2, _omitFieldNames ? '' : 'totalRefundedAmount',
        subBuilder: $1.Money.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'pendingApprovalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundServiceGetStatsResponse copyWith(
          void Function(RefundServiceGetStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RefundServiceGetStatsResponse))
          as RefundServiceGetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RefundServiceGetStatsResponse() / RefundServiceGetStatsResponse.new instead')
  static RefundServiceGetStatsResponse create() =>
      RefundServiceGetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RefundServiceGetStatsResponse._();
  @$core.override
  RefundServiceGetStatsResponse createEmptyInstance() =>
      RefundServiceGetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static RefundServiceGetStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundServiceGetStatsResponse>(
          RefundServiceGetStatsResponse.$_createMessage);
  static RefundServiceGetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalRefunds => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalRefunds($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalRefunds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalRefunds() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Money get totalRefundedAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalRefundedAmount($1.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalRefundedAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalRefundedAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Money ensureTotalRefundedAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get pendingApprovalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set pendingApprovalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingApprovalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingApprovalCount() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
