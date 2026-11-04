// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/affiliate.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'affiliate.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'affiliate.pbenum.dart';

/// Canonical Affiliate Link model.
class AffiliateLink extends $pb.GeneratedMessage {
  factory AffiliateLink({
    $core.String? affiliateLinkId,
    $core.String? workspaceId,
    $core.String? productId,
    $core.String? offerId,
    $core.String? campaignId,
    $core.String? platform,
    $core.String? originalUrl,
    $core.String? trackedUrl,
    $core.String? shortCode,
    $core.String? commissionRate,
    AffiliateLinkLifecycleState? lifecycleState,
    LinkHealthStatus? healthStatus,
    $1.Timestamp? lastHealthCheckAt,
    $core.int? clickCount,
    $core.int? conversionCount,
    $core.String? revenueAttributed,
    $1.Timestamp? expiresAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? suggestedReplacementProductId,
  }) {
    final result = AffiliateLink._();
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (campaignId != null) result.campaignId = campaignId;
    if (platform != null) result.platform = platform;
    if (originalUrl != null) result.originalUrl = originalUrl;
    if (trackedUrl != null) result.trackedUrl = trackedUrl;
    if (shortCode != null) result.shortCode = shortCode;
    if (commissionRate != null) result.commissionRate = commissionRate;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (healthStatus != null) result.healthStatus = healthStatus;
    if (lastHealthCheckAt != null) result.lastHealthCheckAt = lastHealthCheckAt;
    if (clickCount != null) result.clickCount = clickCount;
    if (conversionCount != null) result.conversionCount = conversionCount;
    if (revenueAttributed != null) result.revenueAttributed = revenueAttributed;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (suggestedReplacementProductId != null)
      result.suggestedReplacementProductId = suggestedReplacementProductId;
    return result;
  }

  AffiliateLink._();

  factory AffiliateLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateLink()..mergeFromBuffer(data, registry);
  factory AffiliateLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateLink()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AffiliateLink',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AffiliateLink.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'offerId')
    ..aOS(5, _omitFieldNames ? '' : 'campaignId')
    ..aOS(6, _omitFieldNames ? '' : 'platform')
    ..aOS(7, _omitFieldNames ? '' : 'originalUrl')
    ..aOS(8, _omitFieldNames ? '' : 'trackedUrl')
    ..aOS(9, _omitFieldNames ? '' : 'shortCode')
    ..aOS(10, _omitFieldNames ? '' : 'commissionRate')
    ..aE<AffiliateLinkLifecycleState>(
        11, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: AffiliateLinkLifecycleState.values)
    ..aE<LinkHealthStatus>(12, _omitFieldNames ? '' : 'healthStatus',
        enumValues: LinkHealthStatus.values)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'lastHealthCheckAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aI(14, _omitFieldNames ? '' : 'clickCount')
    ..aI(15, _omitFieldNames ? '' : 'conversionCount')
    ..aOS(16, _omitFieldNames ? '' : 'revenueAttributed')
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(20, _omitFieldNames ? '' : 'suggestedReplacementProductId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateLink copyWith(void Function(AffiliateLink) updates) =>
      super.copyWith((message) => updates(message as AffiliateLink))
          as AffiliateLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AffiliateLink() / AffiliateLink.new instead')
  static AffiliateLink create() => AffiliateLink._();
  static $pb.GeneratedMessage $_createMessage() => AffiliateLink._();
  @$core.override
  AffiliateLink createEmptyInstance() => AffiliateLink._();
  @$core.pragma('dart2js:noInline')
  static AffiliateLink getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AffiliateLink>(
          AffiliateLink.$_createMessage);
  static AffiliateLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get affiliateLinkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set affiliateLinkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAffiliateLinkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAffiliateLinkId() => $_clearField(1);

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
  $core.String get offerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set offerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOfferId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfferId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get campaignId => $_getSZ(4);
  @$pb.TagNumber(5)
  set campaignId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCampaignId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCampaignId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get platform => $_getSZ(5);
  @$pb.TagNumber(6)
  set platform($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlatform() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlatform() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get originalUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set originalUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOriginalUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearOriginalUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get trackedUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set trackedUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrackedUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrackedUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get shortCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set shortCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShortCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearShortCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get commissionRate => $_getSZ(9);
  @$pb.TagNumber(10)
  set commissionRate($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCommissionRate() => $_has(9);
  @$pb.TagNumber(10)
  void clearCommissionRate() => $_clearField(10);

  @$pb.TagNumber(11)
  AffiliateLinkLifecycleState get lifecycleState => $_getN(10);
  @$pb.TagNumber(11)
  set lifecycleState(AffiliateLinkLifecycleState value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLifecycleState() => $_has(10);
  @$pb.TagNumber(11)
  void clearLifecycleState() => $_clearField(11);

  @$pb.TagNumber(12)
  LinkHealthStatus get healthStatus => $_getN(11);
  @$pb.TagNumber(12)
  set healthStatus(LinkHealthStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasHealthStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearHealthStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get lastHealthCheckAt => $_getN(12);
  @$pb.TagNumber(13)
  set lastHealthCheckAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLastHealthCheckAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearLastHealthCheckAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureLastHealthCheckAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.int get clickCount => $_getIZ(13);
  @$pb.TagNumber(14)
  set clickCount($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasClickCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearClickCount() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get conversionCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set conversionCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasConversionCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearConversionCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get revenueAttributed => $_getSZ(15);
  @$pb.TagNumber(16)
  set revenueAttributed($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRevenueAttributed() => $_has(15);
  @$pb.TagNumber(16)
  void clearRevenueAttributed() => $_clearField(16);

  @$pb.TagNumber(17)
  $1.Timestamp get expiresAt => $_getN(16);
  @$pb.TagNumber(17)
  set expiresAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasExpiresAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearExpiresAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureExpiresAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $1.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureUpdatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get suggestedReplacementProductId => $_getSZ(19);
  @$pb.TagNumber(20)
  set suggestedReplacementProductId($core.String value) =>
      $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasSuggestedReplacementProductId() => $_has(19);
  @$pb.TagNumber(20)
  void clearSuggestedReplacementProductId() => $_clearField(20);
}

/// Canonical Creator Assignment model.
class CreatorAssignment extends $pb.GeneratedMessage {
  factory CreatorAssignment({
    $core.String? assignmentId,
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? creatorEntityId,
    $core.String? affiliateLinkId,
    $core.String? couponId,
    AssignmentStatus? status,
    $core.String? notes,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = CreatorAssignment._();
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (couponId != null) result.couponId = couponId;
    if (status != null) result.status = status;
    if (notes != null) result.notes = notes;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CreatorAssignment._();

  factory CreatorAssignment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatorAssignment()..mergeFromBuffer(data, registry);
  factory CreatorAssignment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatorAssignment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatorAssignment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreatorAssignment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assignmentId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'campaignId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(5, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(6, _omitFieldNames ? '' : 'couponId')
    ..aE<AssignmentStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: AssignmentStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'notes')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatorAssignment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatorAssignment copyWith(void Function(CreatorAssignment) updates) =>
      super.copyWith((message) => updates(message as CreatorAssignment))
          as CreatorAssignment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreatorAssignment() / CreatorAssignment.new instead')
  static CreatorAssignment create() => CreatorAssignment._();
  static $pb.GeneratedMessage $_createMessage() => CreatorAssignment._();
  @$core.override
  CreatorAssignment createEmptyInstance() => CreatorAssignment._();
  @$core.pragma('dart2js:noInline')
  static CreatorAssignment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatorAssignment>(
          CreatorAssignment.$_createMessage);
  static CreatorAssignment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assignmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assignmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get campaignId => $_getSZ(2);
  @$pb.TagNumber(3)
  set campaignId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get affiliateLinkId => $_getSZ(4);
  @$pb.TagNumber(5)
  set affiliateLinkId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAffiliateLinkId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAffiliateLinkId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get couponId => $_getSZ(5);
  @$pb.TagNumber(6)
  set couponId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCouponId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCouponId() => $_clearField(6);

  @$pb.TagNumber(7)
  AssignmentStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(AssignmentStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get notes => $_getSZ(7);
  @$pb.TagNumber(8)
  set notes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNotes() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotes() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureUpdatedAt() => $_ensure(9);
}

/// Canonical Attribution Record with explicit provenance.
class AttributionRecord extends $pb.GeneratedMessage {
  factory AttributionRecord({
    $core.String? attributionId,
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? affiliateLinkId,
    $core.String? creatorEntityId,
    $core.String? clickId,
    $core.int? touchpointCount,
    $core.bool? isMultiTouch,
    AttributionSourceClass? sourceClass,
    AttributionConfidence? confidence,
    $core.String? attributionNote,
    $core.String? orderAmount,
    $core.String? attributedRevenue,
    $core.String? commissionAmount,
    $core.String? currency,
    $1.Timestamp? attributedAt,
  }) {
    final result = AttributionRecord._();
    if (attributionId != null) result.attributionId = attributionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (clickId != null) result.clickId = clickId;
    if (touchpointCount != null) result.touchpointCount = touchpointCount;
    if (isMultiTouch != null) result.isMultiTouch = isMultiTouch;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    if (attributionNote != null) result.attributionNote = attributionNote;
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (attributedRevenue != null) result.attributedRevenue = attributedRevenue;
    if (commissionAmount != null) result.commissionAmount = commissionAmount;
    if (currency != null) result.currency = currency;
    if (attributedAt != null) result.attributedAt = attributedAt;
    return result;
  }

  AttributionRecord._();

  factory AttributionRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttributionRecord()..mergeFromBuffer(data, registry);
  factory AttributionRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttributionRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttributionRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AttributionRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'attributionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(5, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(6, _omitFieldNames ? '' : 'clickId')
    ..aI(7, _omitFieldNames ? '' : 'touchpointCount')
    ..aOB(8, _omitFieldNames ? '' : 'isMultiTouch')
    ..aE<AttributionSourceClass>(9, _omitFieldNames ? '' : 'sourceClass',
        enumValues: AttributionSourceClass.values)
    ..aE<AttributionConfidence>(10, _omitFieldNames ? '' : 'confidence',
        enumValues: AttributionConfidence.values)
    ..aOS(11, _omitFieldNames ? '' : 'attributionNote')
    ..aOS(12, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(13, _omitFieldNames ? '' : 'attributedRevenue')
    ..aOS(14, _omitFieldNames ? '' : 'commissionAmount')
    ..aOS(15, _omitFieldNames ? '' : 'currency')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'attributedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttributionRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttributionRecord copyWith(void Function(AttributionRecord) updates) =>
      super.copyWith((message) => updates(message as AttributionRecord))
          as AttributionRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AttributionRecord() / AttributionRecord.new instead')
  static AttributionRecord create() => AttributionRecord._();
  static $pb.GeneratedMessage $_createMessage() => AttributionRecord._();
  @$core.override
  AttributionRecord createEmptyInstance() => AttributionRecord._();
  @$core.pragma('dart2js:noInline')
  static AttributionRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttributionRecord>(
          AttributionRecord.$_createMessage);
  static AttributionRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get attributionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set attributionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttributionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttributionId() => $_clearField(1);

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
  $core.String get affiliateLinkId => $_getSZ(3);
  @$pb.TagNumber(4)
  set affiliateLinkId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAffiliateLinkId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAffiliateLinkId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorEntityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorEntityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get clickId => $_getSZ(5);
  @$pb.TagNumber(6)
  set clickId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClickId() => $_has(5);
  @$pb.TagNumber(6)
  void clearClickId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get touchpointCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set touchpointCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTouchpointCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearTouchpointCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isMultiTouch => $_getBF(7);
  @$pb.TagNumber(8)
  set isMultiTouch($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsMultiTouch() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsMultiTouch() => $_clearField(8);

  @$pb.TagNumber(9)
  AttributionSourceClass get sourceClass => $_getN(8);
  @$pb.TagNumber(9)
  set sourceClass(AttributionSourceClass value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSourceClass() => $_has(8);
  @$pb.TagNumber(9)
  void clearSourceClass() => $_clearField(9);

  @$pb.TagNumber(10)
  AttributionConfidence get confidence => $_getN(9);
  @$pb.TagNumber(10)
  set confidence(AttributionConfidence value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidence() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidence() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get attributionNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set attributionNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAttributionNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearAttributionNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get orderAmount => $_getSZ(11);
  @$pb.TagNumber(12)
  set orderAmount($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOrderAmount() => $_has(11);
  @$pb.TagNumber(12)
  void clearOrderAmount() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get attributedRevenue => $_getSZ(12);
  @$pb.TagNumber(13)
  set attributedRevenue($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAttributedRevenue() => $_has(12);
  @$pb.TagNumber(13)
  void clearAttributedRevenue() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get commissionAmount => $_getSZ(13);
  @$pb.TagNumber(14)
  set commissionAmount($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCommissionAmount() => $_has(13);
  @$pb.TagNumber(14)
  void clearCommissionAmount() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get currency => $_getSZ(14);
  @$pb.TagNumber(15)
  set currency($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCurrency() => $_has(14);
  @$pb.TagNumber(15)
  void clearCurrency() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get attributedAt => $_getN(15);
  @$pb.TagNumber(16)
  set attributedAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasAttributedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearAttributedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureAttributedAt() => $_ensure(15);
}

/// Canonical Affiliate Commission model.
class AffiliateCommission extends $pb.GeneratedMessage {
  factory AffiliateCommission({
    $core.String? commissionId,
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.String? orderId,
    $core.String? creatorEntityId,
    $core.String? commissionAmount,
    $core.String? currency,
    CommissionStatus? status,
    $1.Timestamp? holdUntil,
    $core.String? clawbackReason,
    $core.String? clawbackAmount,
    $core.String? payoutId,
    $1.Timestamp? confirmedAt,
    $1.Timestamp? clawedBackAt,
    $1.Timestamp? paidOutAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = AffiliateCommission._();
    if (commissionId != null) result.commissionId = commissionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (orderId != null) result.orderId = orderId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (commissionAmount != null) result.commissionAmount = commissionAmount;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (holdUntil != null) result.holdUntil = holdUntil;
    if (clawbackReason != null) result.clawbackReason = clawbackReason;
    if (clawbackAmount != null) result.clawbackAmount = clawbackAmount;
    if (payoutId != null) result.payoutId = payoutId;
    if (confirmedAt != null) result.confirmedAt = confirmedAt;
    if (clawedBackAt != null) result.clawedBackAt = clawedBackAt;
    if (paidOutAt != null) result.paidOutAt = paidOutAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  AffiliateCommission._();

  factory AffiliateCommission.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateCommission()..mergeFromBuffer(data, registry);
  factory AffiliateCommission.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateCommission()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AffiliateCommission',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AffiliateCommission.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'commissionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(4, _omitFieldNames ? '' : 'orderId')
    ..aOS(5, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(6, _omitFieldNames ? '' : 'commissionAmount')
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..aE<CommissionStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: CommissionStatus.values)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'holdUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'clawbackReason')
    ..aOS(11, _omitFieldNames ? '' : 'clawbackAmount')
    ..aOS(12, _omitFieldNames ? '' : 'payoutId')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'confirmedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'clawedBackAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'paidOutAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateCommission clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateCommission copyWith(void Function(AffiliateCommission) updates) =>
      super.copyWith((message) => updates(message as AffiliateCommission))
          as AffiliateCommission;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use AffiliateCommission() / AffiliateCommission.new instead')
  static AffiliateCommission create() => AffiliateCommission._();
  static $pb.GeneratedMessage $_createMessage() => AffiliateCommission._();
  @$core.override
  AffiliateCommission createEmptyInstance() => AffiliateCommission._();
  @$core.pragma('dart2js:noInline')
  static AffiliateCommission getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AffiliateCommission>(
          AffiliateCommission.$_createMessage);
  static AffiliateCommission? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commissionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set commissionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommissionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommissionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get affiliateLinkId => $_getSZ(2);
  @$pb.TagNumber(3)
  set affiliateLinkId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAffiliateLinkId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAffiliateLinkId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorEntityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorEntityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get commissionAmount => $_getSZ(5);
  @$pb.TagNumber(6)
  set commissionAmount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCommissionAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCommissionAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  CommissionStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(CommissionStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get holdUntil => $_getN(8);
  @$pb.TagNumber(9)
  set holdUntil($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasHoldUntil() => $_has(8);
  @$pb.TagNumber(9)
  void clearHoldUntil() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureHoldUntil() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get clawbackReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set clawbackReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClawbackReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearClawbackReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get clawbackAmount => $_getSZ(10);
  @$pb.TagNumber(11)
  set clawbackAmount($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClawbackAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearClawbackAmount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get payoutId => $_getSZ(11);
  @$pb.TagNumber(12)
  set payoutId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPayoutId() => $_has(11);
  @$pb.TagNumber(12)
  void clearPayoutId() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get confirmedAt => $_getN(12);
  @$pb.TagNumber(13)
  set confirmedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasConfirmedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearConfirmedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureConfirmedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $1.Timestamp get clawedBackAt => $_getN(13);
  @$pb.TagNumber(14)
  set clawedBackAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasClawedBackAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearClawedBackAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureClawedBackAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $1.Timestamp get paidOutAt => $_getN(14);
  @$pb.TagNumber(15)
  set paidOutAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPaidOutAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearPaidOutAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensurePaidOutAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $1.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureUpdatedAt() => $_ensure(16);
}

/// Canonical Affiliate Payout model.
class AffiliatePayout extends $pb.GeneratedMessage {
  factory AffiliatePayout({
    $core.String? payoutId,
    $core.String? workspaceId,
    $core.String? creatorEntityId,
    $core.Iterable<$core.String>? commissionIds,
    $core.String? totalAmount,
    $core.String? currency,
    PayoutStatus? status,
    $core.String? proofHash,
    $core.String? proofMetadataJson,
    $core.String? settlementId,
    $1.Timestamp? paidAt,
    $1.Timestamp? createdAt,
  }) {
    final result = AffiliatePayout._();
    if (payoutId != null) result.payoutId = payoutId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (commissionIds != null) result.commissionIds.addAll(commissionIds);
    if (totalAmount != null) result.totalAmount = totalAmount;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (proofHash != null) result.proofHash = proofHash;
    if (proofMetadataJson != null) result.proofMetadataJson = proofMetadataJson;
    if (settlementId != null) result.settlementId = settlementId;
    if (paidAt != null) result.paidAt = paidAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  AffiliatePayout._();

  factory AffiliatePayout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliatePayout()..mergeFromBuffer(data, registry);
  factory AffiliatePayout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliatePayout()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AffiliatePayout',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AffiliatePayout.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'payoutId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'creatorEntityId')
    ..pPS(4, _omitFieldNames ? '' : 'commissionIds')
    ..aOS(5, _omitFieldNames ? '' : 'totalAmount')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aE<PayoutStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: PayoutStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'proofHash')
    ..aOS(9, _omitFieldNames ? '' : 'proofMetadataJson')
    ..aOS(10, _omitFieldNames ? '' : 'settlementId')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'paidAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliatePayout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliatePayout copyWith(void Function(AffiliatePayout) updates) =>
      super.copyWith((message) => updates(message as AffiliatePayout))
          as AffiliatePayout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AffiliatePayout() / AffiliatePayout.new instead')
  static AffiliatePayout create() => AffiliatePayout._();
  static $pb.GeneratedMessage $_createMessage() => AffiliatePayout._();
  @$core.override
  AffiliatePayout createEmptyInstance() => AffiliatePayout._();
  @$core.pragma('dart2js:noInline')
  static AffiliatePayout getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AffiliatePayout>(
          AffiliatePayout.$_createMessage);
  static AffiliatePayout? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get payoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set payoutId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorEntityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorEntityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get commissionIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get totalAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set totalAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  PayoutStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(PayoutStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get proofHash => $_getSZ(7);
  @$pb.TagNumber(8)
  set proofHash($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProofHash() => $_has(7);
  @$pb.TagNumber(8)
  void clearProofHash() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get proofMetadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set proofMetadataJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProofMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearProofMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get settlementId => $_getSZ(9);
  @$pb.TagNumber(10)
  set settlementId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSettlementId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSettlementId() => $_clearField(10);

  @$pb.TagNumber(11)
  $1.Timestamp get paidAt => $_getN(10);
  @$pb.TagNumber(11)
  set paidAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPaidAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPaidAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensurePaidAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $1.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureCreatedAt() => $_ensure(11);
}

/// Canonical Link Health Record.
class LinkHealthRecord extends $pb.GeneratedMessage {
  factory LinkHealthRecord({
    $core.String? healthId,
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.int? httpStatus,
    $core.String? productStatus,
    $core.String? commissionStatus,
    LinkHealthStatus? linkStatus,
    $1.Timestamp? expiryDate,
    $core.String? suggestedAction,
    $1.Timestamp? checkedAt,
    $core.bool? alertSent,
    $core.String? estimatedRevenueImpact,
    $core.String? suggestedReplacementProductId,
  }) {
    final result = LinkHealthRecord._();
    if (healthId != null) result.healthId = healthId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (httpStatus != null) result.httpStatus = httpStatus;
    if (productStatus != null) result.productStatus = productStatus;
    if (commissionStatus != null) result.commissionStatus = commissionStatus;
    if (linkStatus != null) result.linkStatus = linkStatus;
    if (expiryDate != null) result.expiryDate = expiryDate;
    if (suggestedAction != null) result.suggestedAction = suggestedAction;
    if (checkedAt != null) result.checkedAt = checkedAt;
    if (alertSent != null) result.alertSent = alertSent;
    if (estimatedRevenueImpact != null)
      result.estimatedRevenueImpact = estimatedRevenueImpact;
    if (suggestedReplacementProductId != null)
      result.suggestedReplacementProductId = suggestedReplacementProductId;
    return result;
  }

  LinkHealthRecord._();

  factory LinkHealthRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkHealthRecord()..mergeFromBuffer(data, registry);
  factory LinkHealthRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkHealthRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkHealthRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkHealthRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'healthId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aI(4, _omitFieldNames ? '' : 'httpStatus')
    ..aOS(5, _omitFieldNames ? '' : 'productStatus')
    ..aOS(6, _omitFieldNames ? '' : 'commissionStatus')
    ..aE<LinkHealthStatus>(7, _omitFieldNames ? '' : 'linkStatus',
        enumValues: LinkHealthStatus.values)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'expiryDate',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'suggestedAction')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'checkedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(11, _omitFieldNames ? '' : 'alertSent')
    ..aOS(12, _omitFieldNames ? '' : 'estimatedRevenueImpact')
    ..aOS(13, _omitFieldNames ? '' : 'suggestedReplacementProductId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkHealthRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkHealthRecord copyWith(void Function(LinkHealthRecord) updates) =>
      super.copyWith((message) => updates(message as LinkHealthRecord))
          as LinkHealthRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkHealthRecord() / LinkHealthRecord.new instead')
  static LinkHealthRecord create() => LinkHealthRecord._();
  static $pb.GeneratedMessage $_createMessage() => LinkHealthRecord._();
  @$core.override
  LinkHealthRecord createEmptyInstance() => LinkHealthRecord._();
  @$core.pragma('dart2js:noInline')
  static LinkHealthRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkHealthRecord>(
          LinkHealthRecord.$_createMessage);
  static LinkHealthRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get healthId => $_getSZ(0);
  @$pb.TagNumber(1)
  set healthId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHealthId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get affiliateLinkId => $_getSZ(2);
  @$pb.TagNumber(3)
  set affiliateLinkId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAffiliateLinkId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAffiliateLinkId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get httpStatus => $_getIZ(3);
  @$pb.TagNumber(4)
  set httpStatus($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHttpStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearHttpStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get productStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set productStatus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProductStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get commissionStatus => $_getSZ(5);
  @$pb.TagNumber(6)
  set commissionStatus($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCommissionStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearCommissionStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  LinkHealthStatus get linkStatus => $_getN(6);
  @$pb.TagNumber(7)
  set linkStatus(LinkHealthStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLinkStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearLinkStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get expiryDate => $_getN(7);
  @$pb.TagNumber(8)
  set expiryDate($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiryDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiryDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureExpiryDate() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get suggestedAction => $_getSZ(8);
  @$pb.TagNumber(9)
  set suggestedAction($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSuggestedAction() => $_has(8);
  @$pb.TagNumber(9)
  void clearSuggestedAction() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get checkedAt => $_getN(9);
  @$pb.TagNumber(10)
  set checkedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCheckedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCheckedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCheckedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get alertSent => $_getBF(10);
  @$pb.TagNumber(11)
  set alertSent($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAlertSent() => $_has(10);
  @$pb.TagNumber(11)
  void clearAlertSent() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get estimatedRevenueImpact => $_getSZ(11);
  @$pb.TagNumber(12)
  set estimatedRevenueImpact($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEstimatedRevenueImpact() => $_has(11);
  @$pb.TagNumber(12)
  void clearEstimatedRevenueImpact() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get suggestedReplacementProductId => $_getSZ(12);
  @$pb.TagNumber(13)
  set suggestedReplacementProductId($core.String value) =>
      $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSuggestedReplacementProductId() => $_has(12);
  @$pb.TagNumber(13)
  void clearSuggestedReplacementProductId() => $_clearField(13);
}

/// Canonical Affiliate Statement for imports and reconciliation.
class AffiliateStatement extends $pb.GeneratedMessage {
  factory AffiliateStatement({
    $core.String? statementId,
    $core.String? workspaceId,
    $core.String? platform,
    $core.String? externalStatementRef,
    $core.String? periodStart,
    $core.String? periodEnd,
    $core.String? totalCommission,
    $core.String? currency,
    $core.String? reconciliationState,
    $core.int? itemCount,
    $core.int? reconciledItemCount,
    $1.Timestamp? importedAt,
  }) {
    final result = AffiliateStatement._();
    if (statementId != null) result.statementId = statementId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (externalStatementRef != null)
      result.externalStatementRef = externalStatementRef;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (totalCommission != null) result.totalCommission = totalCommission;
    if (currency != null) result.currency = currency;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (itemCount != null) result.itemCount = itemCount;
    if (reconciledItemCount != null)
      result.reconciledItemCount = reconciledItemCount;
    if (importedAt != null) result.importedAt = importedAt;
    return result;
  }

  AffiliateStatement._();

  factory AffiliateStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateStatement()..mergeFromBuffer(data, registry);
  factory AffiliateStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateStatement()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AffiliateStatement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AffiliateStatement.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'statementId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'externalStatementRef')
    ..aOS(5, _omitFieldNames ? '' : 'periodStart')
    ..aOS(6, _omitFieldNames ? '' : 'periodEnd')
    ..aOS(7, _omitFieldNames ? '' : 'totalCommission')
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aOS(9, _omitFieldNames ? '' : 'reconciliationState')
    ..aI(10, _omitFieldNames ? '' : 'itemCount')
    ..aI(11, _omitFieldNames ? '' : 'reconciledItemCount')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'importedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateStatement copyWith(void Function(AffiliateStatement) updates) =>
      super.copyWith((message) => updates(message as AffiliateStatement))
          as AffiliateStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AffiliateStatement() / AffiliateStatement.new instead')
  static AffiliateStatement create() => AffiliateStatement._();
  static $pb.GeneratedMessage $_createMessage() => AffiliateStatement._();
  @$core.override
  AffiliateStatement createEmptyInstance() => AffiliateStatement._();
  @$core.pragma('dart2js:noInline')
  static AffiliateStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AffiliateStatement>(
          AffiliateStatement.$_createMessage);
  static AffiliateStatement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get statementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set statementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalStatementRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalStatementRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalStatementRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalStatementRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodEnd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get totalCommission => $_getSZ(6);
  @$pb.TagNumber(7)
  set totalCommission($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalCommission() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCommission() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reconciliationState => $_getSZ(8);
  @$pb.TagNumber(9)
  set reconciliationState($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReconciliationState() => $_has(8);
  @$pb.TagNumber(9)
  void clearReconciliationState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get itemCount => $_getIZ(9);
  @$pb.TagNumber(10)
  set itemCount($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasItemCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearItemCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get reconciledItemCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set reconciledItemCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReconciledItemCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearReconciledItemCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get importedAt => $_getN(11);
  @$pb.TagNumber(12)
  set importedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasImportedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearImportedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureImportedAt() => $_ensure(11);
}

/// Statement item.
class AffiliateStatementItem extends $pb.GeneratedMessage {
  factory AffiliateStatementItem({
    $core.String? itemId,
    $core.String? statementId,
    $core.String? externalOrderId,
    $core.String? orderAmount,
    $core.String? commissionAmount,
    $core.String? matchedOrderId,
    $core.String? matchedCommissionId,
    $core.String? status,
  }) {
    final result = AffiliateStatementItem._();
    if (itemId != null) result.itemId = itemId;
    if (statementId != null) result.statementId = statementId;
    if (externalOrderId != null) result.externalOrderId = externalOrderId;
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (commissionAmount != null) result.commissionAmount = commissionAmount;
    if (matchedOrderId != null) result.matchedOrderId = matchedOrderId;
    if (matchedCommissionId != null)
      result.matchedCommissionId = matchedCommissionId;
    if (status != null) result.status = status;
    return result;
  }

  AffiliateStatementItem._();

  factory AffiliateStatementItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateStatementItem()..mergeFromBuffer(data, registry);
  factory AffiliateStatementItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AffiliateStatementItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AffiliateStatementItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AffiliateStatementItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'statementId')
    ..aOS(3, _omitFieldNames ? '' : 'externalOrderId')
    ..aOS(4, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(5, _omitFieldNames ? '' : 'commissionAmount')
    ..aOS(6, _omitFieldNames ? '' : 'matchedOrderId')
    ..aOS(7, _omitFieldNames ? '' : 'matchedCommissionId')
    ..aOS(8, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateStatementItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AffiliateStatementItem copyWith(
          void Function(AffiliateStatementItem) updates) =>
      super.copyWith((message) => updates(message as AffiliateStatementItem))
          as AffiliateStatementItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AffiliateStatementItem() / AffiliateStatementItem.new instead')
  static AffiliateStatementItem create() => AffiliateStatementItem._();
  static $pb.GeneratedMessage $_createMessage() => AffiliateStatementItem._();
  @$core.override
  AffiliateStatementItem createEmptyInstance() => AffiliateStatementItem._();
  @$core.pragma('dart2js:noInline')
  static AffiliateStatementItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AffiliateStatementItem>(
          AffiliateStatementItem.$_createMessage);
  static AffiliateStatementItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get statementId => $_getSZ(1);
  @$pb.TagNumber(2)
  set statementId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatementId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatementId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get externalOrderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set externalOrderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExternalOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orderAmount => $_getSZ(3);
  @$pb.TagNumber(4)
  set orderAmount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get commissionAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set commissionAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCommissionAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommissionAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get matchedOrderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set matchedOrderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMatchedOrderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMatchedOrderId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get matchedCommissionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set matchedCommissionId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMatchedCommissionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearMatchedCommissionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get status => $_getSZ(7);
  @$pb.TagNumber(8)
  set status($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);
}

/// Ledger posting result reflecting economic role.
class LedgerAffiliatePostingResult extends $pb.GeneratedMessage {
  factory LedgerAffiliatePostingResult({
    $core.String? postingId,
    $core.String? workspaceId,
    WorkspaceEconomicRole? economicRole,
    $core.String? postingType,
    $core.String? amount,
    $core.String? currency,
    $core.bool? cogsDeducted,
    $core.String? netProfitImpact,
    $1.Timestamp? postedAt,
  }) {
    final result = LedgerAffiliatePostingResult._();
    if (postingId != null) result.postingId = postingId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (economicRole != null) result.economicRole = economicRole;
    if (postingType != null) result.postingType = postingType;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (cogsDeducted != null) result.cogsDeducted = cogsDeducted;
    if (netProfitImpact != null) result.netProfitImpact = netProfitImpact;
    if (postedAt != null) result.postedAt = postedAt;
    return result;
  }

  LedgerAffiliatePostingResult._();

  factory LedgerAffiliatePostingResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LedgerAffiliatePostingResult()..mergeFromBuffer(data, registry);
  factory LedgerAffiliatePostingResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LedgerAffiliatePostingResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LedgerAffiliatePostingResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LedgerAffiliatePostingResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'postingId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<WorkspaceEconomicRole>(3, _omitFieldNames ? '' : 'economicRole',
        enumValues: WorkspaceEconomicRole.values)
    ..aOS(4, _omitFieldNames ? '' : 'postingType')
    ..aOS(5, _omitFieldNames ? '' : 'amount')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOB(7, _omitFieldNames ? '' : 'cogsDeducted')
    ..aOS(8, _omitFieldNames ? '' : 'netProfitImpact')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'postedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LedgerAffiliatePostingResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LedgerAffiliatePostingResult copyWith(
          void Function(LedgerAffiliatePostingResult) updates) =>
      super.copyWith(
              (message) => updates(message as LedgerAffiliatePostingResult))
          as LedgerAffiliatePostingResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LedgerAffiliatePostingResult() / LedgerAffiliatePostingResult.new instead')
  static LedgerAffiliatePostingResult create() =>
      LedgerAffiliatePostingResult._();
  static $pb.GeneratedMessage $_createMessage() =>
      LedgerAffiliatePostingResult._();
  @$core.override
  LedgerAffiliatePostingResult createEmptyInstance() =>
      LedgerAffiliatePostingResult._();
  @$core.pragma('dart2js:noInline')
  static LedgerAffiliatePostingResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LedgerAffiliatePostingResult>(
          LedgerAffiliatePostingResult.$_createMessage);
  static LedgerAffiliatePostingResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get postingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set postingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  WorkspaceEconomicRole get economicRole => $_getN(2);
  @$pb.TagNumber(3)
  set economicRole(WorkspaceEconomicRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEconomicRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearEconomicRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get postingType => $_getSZ(3);
  @$pb.TagNumber(4)
  set postingType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPostingType() => $_has(3);
  @$pb.TagNumber(4)
  void clearPostingType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get amount => $_getSZ(4);
  @$pb.TagNumber(5)
  set amount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get cogsDeducted => $_getBF(6);
  @$pb.TagNumber(7)
  set cogsDeducted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCogsDeducted() => $_has(6);
  @$pb.TagNumber(7)
  void clearCogsDeducted() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get netProfitImpact => $_getSZ(7);
  @$pb.TagNumber(8)
  set netProfitImpact($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNetProfitImpact() => $_has(7);
  @$pb.TagNumber(8)
  void clearNetProfitImpact() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get postedAt => $_getN(8);
  @$pb.TagNumber(9)
  set postedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPostedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearPostedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensurePostedAt() => $_ensure(8);
}

class CreateAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory CreateAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? productId,
    $core.String? offerId,
    $core.String? campaignId,
    $core.String? platform,
    $core.String? originalUrl,
    $core.String? commissionRate,
    $core.String? customShortCode,
    $1.Timestamp? expiresAt,
  }) {
    final result = CreateAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (campaignId != null) result.campaignId = campaignId;
    if (platform != null) result.platform = platform;
    if (originalUrl != null) result.originalUrl = originalUrl;
    if (commissionRate != null) result.commissionRate = commissionRate;
    if (customShortCode != null) result.customShortCode = customShortCode;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CreateAffiliateLinkRequest._();

  factory CreateAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory CreateAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'offerId')
    ..aOS(4, _omitFieldNames ? '' : 'campaignId')
    ..aOS(5, _omitFieldNames ? '' : 'platform')
    ..aOS(6, _omitFieldNames ? '' : 'originalUrl')
    ..aOS(7, _omitFieldNames ? '' : 'commissionRate')
    ..aOS(8, _omitFieldNames ? '' : 'customShortCode')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAffiliateLinkRequest copyWith(
          void Function(CreateAffiliateLinkRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateAffiliateLinkRequest))
          as CreateAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateAffiliateLinkRequest() / CreateAffiliateLinkRequest.new instead')
  static CreateAffiliateLinkRequest create() => CreateAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateAffiliateLinkRequest._();
  @$core.override
  CreateAffiliateLinkRequest createEmptyInstance() =>
      CreateAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAffiliateLinkRequest>(
          CreateAffiliateLinkRequest.$_createMessage);
  static CreateAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set offerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get campaignId => $_getSZ(3);
  @$pb.TagNumber(4)
  set campaignId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCampaignId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCampaignId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get platform => $_getSZ(4);
  @$pb.TagNumber(5)
  set platform($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get originalUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set originalUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOriginalUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearOriginalUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get commissionRate => $_getSZ(6);
  @$pb.TagNumber(7)
  set commissionRate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCommissionRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearCommissionRate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get customShortCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set customShortCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCustomShortCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearCustomShortCode() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get expiresAt => $_getN(8);
  @$pb.TagNumber(9)
  set expiresAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureExpiresAt() => $_ensure(8);
}

class CreateAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory CreateAffiliateLinkResponse({
    AffiliateLink? link,
  }) {
    final result = CreateAffiliateLinkResponse._();
    if (link != null) result.link = link;
    return result;
  }

  CreateAffiliateLinkResponse._();

  factory CreateAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory CreateAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateAffiliateLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAffiliateLinkResponse copyWith(
          void Function(CreateAffiliateLinkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateAffiliateLinkResponse))
          as CreateAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateAffiliateLinkResponse() / CreateAffiliateLinkResponse.new instead')
  static CreateAffiliateLinkResponse create() =>
      CreateAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateAffiliateLinkResponse._();
  @$core.override
  CreateAffiliateLinkResponse createEmptyInstance() =>
      CreateAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAffiliateLinkResponse>(
          CreateAffiliateLinkResponse.$_createMessage);
  static CreateAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);
}

class GetAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory GetAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = GetAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  GetAffiliateLinkRequest._();

  factory GetAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory GetAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateLinkRequest copyWith(
          void Function(GetAffiliateLinkRequest) updates) =>
      super.copyWith((message) => updates(message as GetAffiliateLinkRequest))
          as GetAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAffiliateLinkRequest() / GetAffiliateLinkRequest.new instead')
  static GetAffiliateLinkRequest create() => GetAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAffiliateLinkRequest._();
  @$core.override
  GetAffiliateLinkRequest createEmptyInstance() => GetAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAffiliateLinkRequest>(
          GetAffiliateLinkRequest.$_createMessage);
  static GetAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class GetAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory GetAffiliateLinkResponse({
    AffiliateLink? link,
    LinkHealthRecord? latestHealth,
  }) {
    final result = GetAffiliateLinkResponse._();
    if (link != null) result.link = link;
    if (latestHealth != null) result.latestHealth = latestHealth;
    return result;
  }

  GetAffiliateLinkResponse._();

  factory GetAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory GetAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAffiliateLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..aOM<LinkHealthRecord>(2, _omitFieldNames ? '' : 'latestHealth',
        subBuilder: LinkHealthRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateLinkResponse copyWith(
          void Function(GetAffiliateLinkResponse) updates) =>
      super.copyWith((message) => updates(message as GetAffiliateLinkResponse))
          as GetAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAffiliateLinkResponse() / GetAffiliateLinkResponse.new instead')
  static GetAffiliateLinkResponse create() => GetAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetAffiliateLinkResponse._();
  @$core.override
  GetAffiliateLinkResponse createEmptyInstance() =>
      GetAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAffiliateLinkResponse>(
          GetAffiliateLinkResponse.$_createMessage);
  static GetAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);

  @$pb.TagNumber(2)
  LinkHealthRecord get latestHealth => $_getN(1);
  @$pb.TagNumber(2)
  set latestHealth(LinkHealthRecord value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLatestHealth() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatestHealth() => $_clearField(2);
  @$pb.TagNumber(2)
  LinkHealthRecord ensureLatestHealth() => $_ensure(1);
}

class ListAffiliateLinksRequest extends $pb.GeneratedMessage {
  factory ListAffiliateLinksRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? platform,
    AffiliateLinkLifecycleState? lifecycleState,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = ListAffiliateLinksRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (platform != null) result.platform = platform;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListAffiliateLinksRequest._();

  factory ListAffiliateLinksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAffiliateLinksRequest()..mergeFromBuffer(data, registry);
  factory ListAffiliateLinksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAffiliateLinksRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAffiliateLinksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListAffiliateLinksRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aE<AffiliateLinkLifecycleState>(
        4, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: AffiliateLinkLifecycleState.values)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffiliateLinksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffiliateLinksRequest copyWith(
          void Function(ListAffiliateLinksRequest) updates) =>
      super.copyWith((message) => updates(message as ListAffiliateLinksRequest))
          as ListAffiliateLinksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAffiliateLinksRequest() / ListAffiliateLinksRequest.new instead')
  static ListAffiliateLinksRequest create() => ListAffiliateLinksRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListAffiliateLinksRequest._();
  @$core.override
  ListAffiliateLinksRequest createEmptyInstance() =>
      ListAffiliateLinksRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAffiliateLinksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAffiliateLinksRequest>(
          ListAffiliateLinksRequest.$_createMessage);
  static ListAffiliateLinksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  AffiliateLinkLifecycleState get lifecycleState => $_getN(3);
  @$pb.TagNumber(4)
  set lifecycleState(AffiliateLinkLifecycleState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLifecycleState() => $_has(3);
  @$pb.TagNumber(4)
  void clearLifecycleState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class ListAffiliateLinksResponse extends $pb.GeneratedMessage {
  factory ListAffiliateLinksResponse({
    $core.Iterable<AffiliateLink>? links,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = ListAffiliateLinksResponse._();
    if (links != null) result.links.addAll(links);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListAffiliateLinksResponse._();

  factory ListAffiliateLinksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAffiliateLinksResponse()..mergeFromBuffer(data, registry);
  factory ListAffiliateLinksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAffiliateLinksResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAffiliateLinksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListAffiliateLinksResponse.$_createMessage)
    ..pPM<AffiliateLink>(1, _omitFieldNames ? '' : 'links',
        subBuilder: AffiliateLink.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffiliateLinksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffiliateLinksResponse copyWith(
          void Function(ListAffiliateLinksResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListAffiliateLinksResponse))
          as ListAffiliateLinksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAffiliateLinksResponse() / ListAffiliateLinksResponse.new instead')
  static ListAffiliateLinksResponse create() => ListAffiliateLinksResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListAffiliateLinksResponse._();
  @$core.override
  ListAffiliateLinksResponse createEmptyInstance() =>
      ListAffiliateLinksResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAffiliateLinksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAffiliateLinksResponse>(
          ListAffiliateLinksResponse.$_createMessage);
  static ListAffiliateLinksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AffiliateLink> get links => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class UpdateAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory UpdateAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.String? commissionRate,
    $core.String? originalUrl,
    $1.Timestamp? expiresAt,
  }) {
    final result = UpdateAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (commissionRate != null) result.commissionRate = commissionRate;
    if (originalUrl != null) result.originalUrl = originalUrl;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  UpdateAffiliateLinkRequest._();

  factory UpdateAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory UpdateAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(3, _omitFieldNames ? '' : 'commissionRate')
    ..aOS(4, _omitFieldNames ? '' : 'originalUrl')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAffiliateLinkRequest copyWith(
          void Function(UpdateAffiliateLinkRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateAffiliateLinkRequest))
          as UpdateAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAffiliateLinkRequest() / UpdateAffiliateLinkRequest.new instead')
  static UpdateAffiliateLinkRequest create() => UpdateAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateAffiliateLinkRequest._();
  @$core.override
  UpdateAffiliateLinkRequest createEmptyInstance() =>
      UpdateAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAffiliateLinkRequest>(
          UpdateAffiliateLinkRequest.$_createMessage);
  static UpdateAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commissionRate => $_getSZ(2);
  @$pb.TagNumber(3)
  set commissionRate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommissionRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommissionRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get originalUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set originalUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOriginalUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginalUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureExpiresAt() => $_ensure(4);
}

class UpdateAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory UpdateAffiliateLinkResponse({
    AffiliateLink? link,
  }) {
    final result = UpdateAffiliateLinkResponse._();
    if (link != null) result.link = link;
    return result;
  }

  UpdateAffiliateLinkResponse._();

  factory UpdateAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory UpdateAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateAffiliateLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAffiliateLinkResponse copyWith(
          void Function(UpdateAffiliateLinkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateAffiliateLinkResponse))
          as UpdateAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAffiliateLinkResponse() / UpdateAffiliateLinkResponse.new instead')
  static UpdateAffiliateLinkResponse create() =>
      UpdateAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateAffiliateLinkResponse._();
  @$core.override
  UpdateAffiliateLinkResponse createEmptyInstance() =>
      UpdateAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAffiliateLinkResponse>(
          UpdateAffiliateLinkResponse.$_createMessage);
  static UpdateAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);
}

class DeleteAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory DeleteAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = DeleteAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  DeleteAffiliateLinkRequest._();

  factory DeleteAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory DeleteAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: DeleteAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAffiliateLinkRequest copyWith(
          void Function(DeleteAffiliateLinkRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteAffiliateLinkRequest))
          as DeleteAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAffiliateLinkRequest() / DeleteAffiliateLinkRequest.new instead')
  static DeleteAffiliateLinkRequest create() => DeleteAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteAffiliateLinkRequest._();
  @$core.override
  DeleteAffiliateLinkRequest createEmptyInstance() =>
      DeleteAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAffiliateLinkRequest>(
          DeleteAffiliateLinkRequest.$_createMessage);
  static DeleteAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class DeleteAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory DeleteAffiliateLinkResponse({
    $core.bool? success,
  }) {
    final result = DeleteAffiliateLinkResponse._();
    if (success != null) result.success = success;
    return result;
  }

  DeleteAffiliateLinkResponse._();

  factory DeleteAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory DeleteAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: DeleteAffiliateLinkResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAffiliateLinkResponse copyWith(
          void Function(DeleteAffiliateLinkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteAffiliateLinkResponse))
          as DeleteAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteAffiliateLinkResponse() / DeleteAffiliateLinkResponse.new instead')
  static DeleteAffiliateLinkResponse create() =>
      DeleteAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteAffiliateLinkResponse._();
  @$core.override
  DeleteAffiliateLinkResponse createEmptyInstance() =>
      DeleteAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAffiliateLinkResponse>(
          DeleteAffiliateLinkResponse.$_createMessage);
  static DeleteAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class PauseAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory PauseAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = PauseAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  PauseAffiliateLinkRequest._();

  factory PauseAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory PauseAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PauseAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseAffiliateLinkRequest copyWith(
          void Function(PauseAffiliateLinkRequest) updates) =>
      super.copyWith((message) => updates(message as PauseAffiliateLinkRequest))
          as PauseAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PauseAffiliateLinkRequest() / PauseAffiliateLinkRequest.new instead')
  static PauseAffiliateLinkRequest create() => PauseAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      PauseAffiliateLinkRequest._();
  @$core.override
  PauseAffiliateLinkRequest createEmptyInstance() =>
      PauseAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static PauseAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseAffiliateLinkRequest>(
          PauseAffiliateLinkRequest.$_createMessage);
  static PauseAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class PauseAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory PauseAffiliateLinkResponse({
    AffiliateLink? link,
  }) {
    final result = PauseAffiliateLinkResponse._();
    if (link != null) result.link = link;
    return result;
  }

  PauseAffiliateLinkResponse._();

  factory PauseAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory PauseAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PauseAffiliateLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseAffiliateLinkResponse copyWith(
          void Function(PauseAffiliateLinkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PauseAffiliateLinkResponse))
          as PauseAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PauseAffiliateLinkResponse() / PauseAffiliateLinkResponse.new instead')
  static PauseAffiliateLinkResponse create() => PauseAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      PauseAffiliateLinkResponse._();
  @$core.override
  PauseAffiliateLinkResponse createEmptyInstance() =>
      PauseAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static PauseAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseAffiliateLinkResponse>(
          PauseAffiliateLinkResponse.$_createMessage);
  static PauseAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);
}

class ResumeAffiliateLinkRequest extends $pb.GeneratedMessage {
  factory ResumeAffiliateLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = ResumeAffiliateLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  ResumeAffiliateLinkRequest._();

  factory ResumeAffiliateLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeAffiliateLinkRequest()..mergeFromBuffer(data, registry);
  factory ResumeAffiliateLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeAffiliateLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeAffiliateLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ResumeAffiliateLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeAffiliateLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeAffiliateLinkRequest copyWith(
          void Function(ResumeAffiliateLinkRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ResumeAffiliateLinkRequest))
          as ResumeAffiliateLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeAffiliateLinkRequest() / ResumeAffiliateLinkRequest.new instead')
  static ResumeAffiliateLinkRequest create() => ResumeAffiliateLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ResumeAffiliateLinkRequest._();
  @$core.override
  ResumeAffiliateLinkRequest createEmptyInstance() =>
      ResumeAffiliateLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static ResumeAffiliateLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeAffiliateLinkRequest>(
          ResumeAffiliateLinkRequest.$_createMessage);
  static ResumeAffiliateLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class ResumeAffiliateLinkResponse extends $pb.GeneratedMessage {
  factory ResumeAffiliateLinkResponse({
    AffiliateLink? link,
  }) {
    final result = ResumeAffiliateLinkResponse._();
    if (link != null) result.link = link;
    return result;
  }

  ResumeAffiliateLinkResponse._();

  factory ResumeAffiliateLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeAffiliateLinkResponse()..mergeFromBuffer(data, registry);
  factory ResumeAffiliateLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeAffiliateLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeAffiliateLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ResumeAffiliateLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeAffiliateLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeAffiliateLinkResponse copyWith(
          void Function(ResumeAffiliateLinkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ResumeAffiliateLinkResponse))
          as ResumeAffiliateLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeAffiliateLinkResponse() / ResumeAffiliateLinkResponse.new instead')
  static ResumeAffiliateLinkResponse create() =>
      ResumeAffiliateLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ResumeAffiliateLinkResponse._();
  @$core.override
  ResumeAffiliateLinkResponse createEmptyInstance() =>
      ResumeAffiliateLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static ResumeAffiliateLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeAffiliateLinkResponse>(
          ResumeAffiliateLinkResponse.$_createMessage);
  static ResumeAffiliateLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);
}

class GetAffiliateAnalyticsRequest extends $pb.GeneratedMessage {
  factory GetAffiliateAnalyticsRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = GetAffiliateAnalyticsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  GetAffiliateAnalyticsRequest._();

  factory GetAffiliateAnalyticsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateAnalyticsRequest()..mergeFromBuffer(data, registry);
  factory GetAffiliateAnalyticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateAnalyticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAffiliateAnalyticsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAffiliateAnalyticsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateAnalyticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateAnalyticsRequest copyWith(
          void Function(GetAffiliateAnalyticsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetAffiliateAnalyticsRequest))
          as GetAffiliateAnalyticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAffiliateAnalyticsRequest() / GetAffiliateAnalyticsRequest.new instead')
  static GetAffiliateAnalyticsRequest create() =>
      GetAffiliateAnalyticsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAffiliateAnalyticsRequest._();
  @$core.override
  GetAffiliateAnalyticsRequest createEmptyInstance() =>
      GetAffiliateAnalyticsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAffiliateAnalyticsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAffiliateAnalyticsRequest>(
          GetAffiliateAnalyticsRequest.$_createMessage);
  static GetAffiliateAnalyticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class GetAffiliateAnalyticsResponse extends $pb.GeneratedMessage {
  factory GetAffiliateAnalyticsResponse({
    $core.String? affiliateLinkId,
    $core.int? clickCount,
    $core.int? conversionCount,
    $core.String? revenueAttributed,
    $core.String? totalCommissionEarned,
    $core.String? currency,
  }) {
    final result = GetAffiliateAnalyticsResponse._();
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (clickCount != null) result.clickCount = clickCount;
    if (conversionCount != null) result.conversionCount = conversionCount;
    if (revenueAttributed != null) result.revenueAttributed = revenueAttributed;
    if (totalCommissionEarned != null)
      result.totalCommissionEarned = totalCommissionEarned;
    if (currency != null) result.currency = currency;
    return result;
  }

  GetAffiliateAnalyticsResponse._();

  factory GetAffiliateAnalyticsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateAnalyticsResponse()..mergeFromBuffer(data, registry);
  factory GetAffiliateAnalyticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAffiliateAnalyticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAffiliateAnalyticsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAffiliateAnalyticsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aI(2, _omitFieldNames ? '' : 'clickCount')
    ..aI(3, _omitFieldNames ? '' : 'conversionCount')
    ..aOS(4, _omitFieldNames ? '' : 'revenueAttributed')
    ..aOS(5, _omitFieldNames ? '' : 'totalCommissionEarned')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateAnalyticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAffiliateAnalyticsResponse copyWith(
          void Function(GetAffiliateAnalyticsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetAffiliateAnalyticsResponse))
          as GetAffiliateAnalyticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAffiliateAnalyticsResponse() / GetAffiliateAnalyticsResponse.new instead')
  static GetAffiliateAnalyticsResponse create() =>
      GetAffiliateAnalyticsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAffiliateAnalyticsResponse._();
  @$core.override
  GetAffiliateAnalyticsResponse createEmptyInstance() =>
      GetAffiliateAnalyticsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAffiliateAnalyticsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAffiliateAnalyticsResponse>(
          GetAffiliateAnalyticsResponse.$_createMessage);
  static GetAffiliateAnalyticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get affiliateLinkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set affiliateLinkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAffiliateLinkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAffiliateLinkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get clickCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set clickCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClickCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearClickCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get conversionCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set conversionCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConversionCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearConversionCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get revenueAttributed => $_getSZ(3);
  @$pb.TagNumber(4)
  set revenueAttributed($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevenueAttributed() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevenueAttributed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get totalCommissionEarned => $_getSZ(4);
  @$pb.TagNumber(5)
  set totalCommissionEarned($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalCommissionEarned() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalCommissionEarned() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);
}

class CreateAssignmentRequest extends $pb.GeneratedMessage {
  factory CreateAssignmentRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? creatorEntityId,
    $core.String? affiliateLinkId,
    $core.String? couponId,
    $core.String? notes,
  }) {
    final result = CreateAssignmentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (couponId != null) result.couponId = couponId;
    if (notes != null) result.notes = notes;
    return result;
  }

  CreateAssignmentRequest._();

  factory CreateAssignmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAssignmentRequest()..mergeFromBuffer(data, registry);
  factory CreateAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAssignmentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateAssignmentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(4, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(5, _omitFieldNames ? '' : 'couponId')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAssignmentRequest copyWith(
          void Function(CreateAssignmentRequest) updates) =>
      super.copyWith((message) => updates(message as CreateAssignmentRequest))
          as CreateAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateAssignmentRequest() / CreateAssignmentRequest.new instead')
  static CreateAssignmentRequest create() => CreateAssignmentRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateAssignmentRequest._();
  @$core.override
  CreateAssignmentRequest createEmptyInstance() => CreateAssignmentRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateAssignmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAssignmentRequest>(
          CreateAssignmentRequest.$_createMessage);
  static CreateAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorEntityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorEntityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get affiliateLinkId => $_getSZ(3);
  @$pb.TagNumber(4)
  set affiliateLinkId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAffiliateLinkId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAffiliateLinkId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get couponId => $_getSZ(4);
  @$pb.TagNumber(5)
  set couponId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCouponId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCouponId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);
}

class CreateAssignmentResponse extends $pb.GeneratedMessage {
  factory CreateAssignmentResponse({
    CreatorAssignment? assignment,
  }) {
    final result = CreateAssignmentResponse._();
    if (assignment != null) result.assignment = assignment;
    return result;
  }

  CreateAssignmentResponse._();

  factory CreateAssignmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAssignmentResponse()..mergeFromBuffer(data, registry);
  factory CreateAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAssignmentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreateAssignmentResponse.$_createMessage)
    ..aOM<CreatorAssignment>(1, _omitFieldNames ? '' : 'assignment',
        subBuilder: CreatorAssignment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAssignmentResponse copyWith(
          void Function(CreateAssignmentResponse) updates) =>
      super.copyWith((message) => updates(message as CreateAssignmentResponse))
          as CreateAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateAssignmentResponse() / CreateAssignmentResponse.new instead')
  static CreateAssignmentResponse create() => CreateAssignmentResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateAssignmentResponse._();
  @$core.override
  CreateAssignmentResponse createEmptyInstance() =>
      CreateAssignmentResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateAssignmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAssignmentResponse>(
          CreateAssignmentResponse.$_createMessage);
  static CreateAssignmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreatorAssignment get assignment => $_getN(0);
  @$pb.TagNumber(1)
  set assignment(CreatorAssignment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignment() => $_clearField(1);
  @$pb.TagNumber(1)
  CreatorAssignment ensureAssignment() => $_ensure(0);
}

class ListAssignmentsRequest extends $pb.GeneratedMessage {
  factory ListAssignmentsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? creatorEntityId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = ListAssignmentsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListAssignmentsRequest._();

  factory ListAssignmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAssignmentsRequest()..mergeFromBuffer(data, registry);
  factory ListAssignmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAssignmentsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssignmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListAssignmentsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'creatorEntityId')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsRequest copyWith(
          void Function(ListAssignmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAssignmentsRequest))
          as ListAssignmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAssignmentsRequest() / ListAssignmentsRequest.new instead')
  static ListAssignmentsRequest create() => ListAssignmentsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAssignmentsRequest._();
  @$core.override
  ListAssignmentsRequest createEmptyInstance() => ListAssignmentsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAssignmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssignmentsRequest>(
          ListAssignmentsRequest.$_createMessage);
  static ListAssignmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorEntityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorEntityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);
}

class ListAssignmentsResponse extends $pb.GeneratedMessage {
  factory ListAssignmentsResponse({
    $core.Iterable<CreatorAssignment>? assignments,
    $core.String? nextPageToken,
  }) {
    final result = ListAssignmentsResponse._();
    if (assignments != null) result.assignments.addAll(assignments);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListAssignmentsResponse._();

  factory ListAssignmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAssignmentsResponse()..mergeFromBuffer(data, registry);
  factory ListAssignmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAssignmentsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssignmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListAssignmentsResponse.$_createMessage)
    ..pPM<CreatorAssignment>(1, _omitFieldNames ? '' : 'assignments',
        subBuilder: CreatorAssignment.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsResponse copyWith(
          void Function(ListAssignmentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAssignmentsResponse))
          as ListAssignmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAssignmentsResponse() / ListAssignmentsResponse.new instead')
  static ListAssignmentsResponse create() => ListAssignmentsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAssignmentsResponse._();
  @$core.override
  ListAssignmentsResponse createEmptyInstance() => ListAssignmentsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAssignmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssignmentsResponse>(
          ListAssignmentsResponse.$_createMessage);
  static ListAssignmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreatorAssignment> get assignments => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class UpdateAssignmentRequest extends $pb.GeneratedMessage {
  factory UpdateAssignmentRequest({
    $core.String? workspaceId,
    $core.String? assignmentId,
    AssignmentStatus? status,
    $core.String? notes,
  }) {
    final result = UpdateAssignmentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (status != null) result.status = status;
    if (notes != null) result.notes = notes;
    return result;
  }

  UpdateAssignmentRequest._();

  factory UpdateAssignmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAssignmentRequest()..mergeFromBuffer(data, registry);
  factory UpdateAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAssignmentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateAssignmentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'assignmentId')
    ..aE<AssignmentStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: AssignmentStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAssignmentRequest copyWith(
          void Function(UpdateAssignmentRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateAssignmentRequest))
          as UpdateAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAssignmentRequest() / UpdateAssignmentRequest.new instead')
  static UpdateAssignmentRequest create() => UpdateAssignmentRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAssignmentRequest._();
  @$core.override
  UpdateAssignmentRequest createEmptyInstance() => UpdateAssignmentRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateAssignmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAssignmentRequest>(
          UpdateAssignmentRequest.$_createMessage);
  static UpdateAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assignmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assignmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssignmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssignmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  AssignmentStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(AssignmentStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class UpdateAssignmentResponse extends $pb.GeneratedMessage {
  factory UpdateAssignmentResponse({
    CreatorAssignment? assignment,
  }) {
    final result = UpdateAssignmentResponse._();
    if (assignment != null) result.assignment = assignment;
    return result;
  }

  UpdateAssignmentResponse._();

  factory UpdateAssignmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAssignmentResponse()..mergeFromBuffer(data, registry);
  factory UpdateAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAssignmentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateAssignmentResponse.$_createMessage)
    ..aOM<CreatorAssignment>(1, _omitFieldNames ? '' : 'assignment',
        subBuilder: CreatorAssignment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAssignmentResponse copyWith(
          void Function(UpdateAssignmentResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateAssignmentResponse))
          as UpdateAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAssignmentResponse() / UpdateAssignmentResponse.new instead')
  static UpdateAssignmentResponse create() => UpdateAssignmentResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAssignmentResponse._();
  @$core.override
  UpdateAssignmentResponse createEmptyInstance() =>
      UpdateAssignmentResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateAssignmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAssignmentResponse>(
          UpdateAssignmentResponse.$_createMessage);
  static UpdateAssignmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreatorAssignment get assignment => $_getN(0);
  @$pb.TagNumber(1)
  set assignment(CreatorAssignment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignment() => $_clearField(1);
  @$pb.TagNumber(1)
  CreatorAssignment ensureAssignment() => $_ensure(0);
}

class RecordAttributionRequest extends $pb.GeneratedMessage {
  factory RecordAttributionRequest({
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? affiliateLinkId,
    $core.String? creatorEntityId,
    $core.String? clickId,
    $core.int? touchpointCount,
    $core.bool? isMultiTouch,
    $core.String? orderAmount,
    $core.String? currency,
    $core.bool? isOfficialApi,
  }) {
    final result = RecordAttributionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (clickId != null) result.clickId = clickId;
    if (touchpointCount != null) result.touchpointCount = touchpointCount;
    if (isMultiTouch != null) result.isMultiTouch = isMultiTouch;
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (currency != null) result.currency = currency;
    if (isOfficialApi != null) result.isOfficialApi = isOfficialApi;
    return result;
  }

  RecordAttributionRequest._();

  factory RecordAttributionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecordAttributionRequest()..mergeFromBuffer(data, registry);
  factory RecordAttributionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecordAttributionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAttributionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RecordAttributionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOS(3, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(5, _omitFieldNames ? '' : 'clickId')
    ..aI(6, _omitFieldNames ? '' : 'touchpointCount')
    ..aOB(7, _omitFieldNames ? '' : 'isMultiTouch')
    ..aOS(8, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(9, _omitFieldNames ? '' : 'currency')
    ..aOB(10, _omitFieldNames ? '' : 'isOfficialApi')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAttributionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAttributionRequest copyWith(
          void Function(RecordAttributionRequest) updates) =>
      super.copyWith((message) => updates(message as RecordAttributionRequest))
          as RecordAttributionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecordAttributionRequest() / RecordAttributionRequest.new instead')
  static RecordAttributionRequest create() => RecordAttributionRequest._();
  static $pb.GeneratedMessage $_createMessage() => RecordAttributionRequest._();
  @$core.override
  RecordAttributionRequest createEmptyInstance() =>
      RecordAttributionRequest._();
  @$core.pragma('dart2js:noInline')
  static RecordAttributionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAttributionRequest>(
          RecordAttributionRequest.$_createMessage);
  static RecordAttributionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get affiliateLinkId => $_getSZ(2);
  @$pb.TagNumber(3)
  set affiliateLinkId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAffiliateLinkId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAffiliateLinkId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get clickId => $_getSZ(4);
  @$pb.TagNumber(5)
  set clickId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClickId() => $_has(4);
  @$pb.TagNumber(5)
  void clearClickId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get touchpointCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set touchpointCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTouchpointCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearTouchpointCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isMultiTouch => $_getBF(6);
  @$pb.TagNumber(7)
  set isMultiTouch($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsMultiTouch() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsMultiTouch() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get orderAmount => $_getSZ(7);
  @$pb.TagNumber(8)
  set orderAmount($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrderAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrderAmount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get currency => $_getSZ(8);
  @$pb.TagNumber(9)
  set currency($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrency() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrency() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isOfficialApi => $_getBF(9);
  @$pb.TagNumber(10)
  set isOfficialApi($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsOfficialApi() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsOfficialApi() => $_clearField(10);
}

class RecordAttributionResponse extends $pb.GeneratedMessage {
  factory RecordAttributionResponse({
    AttributionRecord? attribution,
  }) {
    final result = RecordAttributionResponse._();
    if (attribution != null) result.attribution = attribution;
    return result;
  }

  RecordAttributionResponse._();

  factory RecordAttributionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecordAttributionResponse()..mergeFromBuffer(data, registry);
  factory RecordAttributionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecordAttributionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAttributionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RecordAttributionResponse.$_createMessage)
    ..aOM<AttributionRecord>(1, _omitFieldNames ? '' : 'attribution',
        subBuilder: AttributionRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAttributionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAttributionResponse copyWith(
          void Function(RecordAttributionResponse) updates) =>
      super.copyWith((message) => updates(message as RecordAttributionResponse))
          as RecordAttributionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecordAttributionResponse() / RecordAttributionResponse.new instead')
  static RecordAttributionResponse create() => RecordAttributionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecordAttributionResponse._();
  @$core.override
  RecordAttributionResponse createEmptyInstance() =>
      RecordAttributionResponse._();
  @$core.pragma('dart2js:noInline')
  static RecordAttributionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAttributionResponse>(
          RecordAttributionResponse.$_createMessage);
  static RecordAttributionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AttributionRecord get attribution => $_getN(0);
  @$pb.TagNumber(1)
  set attribution(AttributionRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAttribution() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttribution() => $_clearField(1);
  @$pb.TagNumber(1)
  AttributionRecord ensureAttribution() => $_ensure(0);
}

class GetAttributionReportRequest extends $pb.GeneratedMessage {
  factory GetAttributionReportRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
  }) {
    final result = GetAttributionReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    return result;
  }

  GetAttributionReportRequest._();

  factory GetAttributionReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAttributionReportRequest()..mergeFromBuffer(data, registry);
  factory GetAttributionReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAttributionReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAttributionReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAttributionReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttributionReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttributionReportRequest copyWith(
          void Function(GetAttributionReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetAttributionReportRequest))
          as GetAttributionReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAttributionReportRequest() / GetAttributionReportRequest.new instead')
  static GetAttributionReportRequest create() =>
      GetAttributionReportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAttributionReportRequest._();
  @$core.override
  GetAttributionReportRequest createEmptyInstance() =>
      GetAttributionReportRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAttributionReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAttributionReportRequest>(
          GetAttributionReportRequest.$_createMessage);
  static GetAttributionReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);
}

class GetAttributionReportResponse extends $pb.GeneratedMessage {
  factory GetAttributionReportResponse({
    $core.Iterable<AttributionRecord>? attributions,
    $core.int? officialCount,
    $core.int? inferredCount,
    $core.int? importedCount,
    $core.int? unreconciledCount,
    $core.String? totalAttributedRevenue,
  }) {
    final result = GetAttributionReportResponse._();
    if (attributions != null) result.attributions.addAll(attributions);
    if (officialCount != null) result.officialCount = officialCount;
    if (inferredCount != null) result.inferredCount = inferredCount;
    if (importedCount != null) result.importedCount = importedCount;
    if (unreconciledCount != null) result.unreconciledCount = unreconciledCount;
    if (totalAttributedRevenue != null)
      result.totalAttributedRevenue = totalAttributedRevenue;
    return result;
  }

  GetAttributionReportResponse._();

  factory GetAttributionReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAttributionReportResponse()..mergeFromBuffer(data, registry);
  factory GetAttributionReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAttributionReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAttributionReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAttributionReportResponse.$_createMessage)
    ..pPM<AttributionRecord>(1, _omitFieldNames ? '' : 'attributions',
        subBuilder: AttributionRecord.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'officialCount')
    ..aI(3, _omitFieldNames ? '' : 'inferredCount')
    ..aI(4, _omitFieldNames ? '' : 'importedCount')
    ..aI(5, _omitFieldNames ? '' : 'unreconciledCount')
    ..aOS(6, _omitFieldNames ? '' : 'totalAttributedRevenue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttributionReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttributionReportResponse copyWith(
          void Function(GetAttributionReportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetAttributionReportResponse))
          as GetAttributionReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAttributionReportResponse() / GetAttributionReportResponse.new instead')
  static GetAttributionReportResponse create() =>
      GetAttributionReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAttributionReportResponse._();
  @$core.override
  GetAttributionReportResponse createEmptyInstance() =>
      GetAttributionReportResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAttributionReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAttributionReportResponse>(
          GetAttributionReportResponse.$_createMessage);
  static GetAttributionReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AttributionRecord> get attributions => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get officialCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set officialCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfficialCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfficialCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get inferredCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set inferredCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInferredCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearInferredCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get importedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set importedCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImportedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearImportedCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unreconciledCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set unreconciledCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnreconciledCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnreconciledCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get totalAttributedRevenue => $_getSZ(5);
  @$pb.TagNumber(6)
  set totalAttributedRevenue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalAttributedRevenue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalAttributedRevenue() => $_clearField(6);
}

class CalculateCommissionRequest extends $pb.GeneratedMessage {
  factory CalculateCommissionRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.String? orderId,
    $core.String? creatorEntityId,
    $core.String? orderAmount,
    $core.String? currency,
    $core.int? holdPeriodDays,
  }) {
    final result = CalculateCommissionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (orderId != null) result.orderId = orderId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (currency != null) result.currency = currency;
    if (holdPeriodDays != null) result.holdPeriodDays = holdPeriodDays;
    return result;
  }

  CalculateCommissionRequest._();

  factory CalculateCommissionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateCommissionRequest()..mergeFromBuffer(data, registry);
  factory CalculateCommissionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateCommissionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculateCommissionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CalculateCommissionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(5, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aI(7, _omitFieldNames ? '' : 'holdPeriodDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateCommissionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateCommissionRequest copyWith(
          void Function(CalculateCommissionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CalculateCommissionRequest))
          as CalculateCommissionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CalculateCommissionRequest() / CalculateCommissionRequest.new instead')
  static CalculateCommissionRequest create() => CalculateCommissionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CalculateCommissionRequest._();
  @$core.override
  CalculateCommissionRequest createEmptyInstance() =>
      CalculateCommissionRequest._();
  @$core.pragma('dart2js:noInline')
  static CalculateCommissionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateCommissionRequest>(
          CalculateCommissionRequest.$_createMessage);
  static CalculateCommissionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get orderAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set orderAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get holdPeriodDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set holdPeriodDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHoldPeriodDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearHoldPeriodDays() => $_clearField(7);
}

class CalculateCommissionResponse extends $pb.GeneratedMessage {
  factory CalculateCommissionResponse({
    AffiliateCommission? commission,
  }) {
    final result = CalculateCommissionResponse._();
    if (commission != null) result.commission = commission;
    return result;
  }

  CalculateCommissionResponse._();

  factory CalculateCommissionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateCommissionResponse()..mergeFromBuffer(data, registry);
  factory CalculateCommissionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateCommissionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculateCommissionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CalculateCommissionResponse.$_createMessage)
    ..aOM<AffiliateCommission>(1, _omitFieldNames ? '' : 'commission',
        subBuilder: AffiliateCommission.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateCommissionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateCommissionResponse copyWith(
          void Function(CalculateCommissionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CalculateCommissionResponse))
          as CalculateCommissionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CalculateCommissionResponse() / CalculateCommissionResponse.new instead')
  static CalculateCommissionResponse create() =>
      CalculateCommissionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CalculateCommissionResponse._();
  @$core.override
  CalculateCommissionResponse createEmptyInstance() =>
      CalculateCommissionResponse._();
  @$core.pragma('dart2js:noInline')
  static CalculateCommissionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateCommissionResponse>(
          CalculateCommissionResponse.$_createMessage);
  static CalculateCommissionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateCommission get commission => $_getN(0);
  @$pb.TagNumber(1)
  set commission(AffiliateCommission value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCommission() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommission() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateCommission ensureCommission() => $_ensure(0);
}

class ConfirmCommissionRequest extends $pb.GeneratedMessage {
  factory ConfirmCommissionRequest({
    $core.String? workspaceId,
    $core.String? commissionId,
  }) {
    final result = ConfirmCommissionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (commissionId != null) result.commissionId = commissionId;
    return result;
  }

  ConfirmCommissionRequest._();

  factory ConfirmCommissionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmCommissionRequest()..mergeFromBuffer(data, registry);
  factory ConfirmCommissionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmCommissionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmCommissionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ConfirmCommissionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'commissionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmCommissionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmCommissionRequest copyWith(
          void Function(ConfirmCommissionRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmCommissionRequest))
          as ConfirmCommissionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConfirmCommissionRequest() / ConfirmCommissionRequest.new instead')
  static ConfirmCommissionRequest create() => ConfirmCommissionRequest._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmCommissionRequest._();
  @$core.override
  ConfirmCommissionRequest createEmptyInstance() =>
      ConfirmCommissionRequest._();
  @$core.pragma('dart2js:noInline')
  static ConfirmCommissionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmCommissionRequest>(
          ConfirmCommissionRequest.$_createMessage);
  static ConfirmCommissionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commissionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set commissionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommissionId() => $_clearField(2);
}

class ConfirmCommissionResponse extends $pb.GeneratedMessage {
  factory ConfirmCommissionResponse({
    AffiliateCommission? commission,
  }) {
    final result = ConfirmCommissionResponse._();
    if (commission != null) result.commission = commission;
    return result;
  }

  ConfirmCommissionResponse._();

  factory ConfirmCommissionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmCommissionResponse()..mergeFromBuffer(data, registry);
  factory ConfirmCommissionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmCommissionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmCommissionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ConfirmCommissionResponse.$_createMessage)
    ..aOM<AffiliateCommission>(1, _omitFieldNames ? '' : 'commission',
        subBuilder: AffiliateCommission.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmCommissionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmCommissionResponse copyWith(
          void Function(ConfirmCommissionResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmCommissionResponse))
          as ConfirmCommissionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConfirmCommissionResponse() / ConfirmCommissionResponse.new instead')
  static ConfirmCommissionResponse create() => ConfirmCommissionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConfirmCommissionResponse._();
  @$core.override
  ConfirmCommissionResponse createEmptyInstance() =>
      ConfirmCommissionResponse._();
  @$core.pragma('dart2js:noInline')
  static ConfirmCommissionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmCommissionResponse>(
          ConfirmCommissionResponse.$_createMessage);
  static ConfirmCommissionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateCommission get commission => $_getN(0);
  @$pb.TagNumber(1)
  set commission(AffiliateCommission value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCommission() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommission() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateCommission ensureCommission() => $_ensure(0);
}

class ClawbackCommissionRequest extends $pb.GeneratedMessage {
  factory ClawbackCommissionRequest({
    $core.String? workspaceId,
    $core.String? commissionId,
    $core.String? reason,
    $core.String? amount,
  }) {
    final result = ClawbackCommissionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (commissionId != null) result.commissionId = commissionId;
    if (reason != null) result.reason = reason;
    if (amount != null) result.amount = amount;
    return result;
  }

  ClawbackCommissionRequest._();

  factory ClawbackCommissionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClawbackCommissionRequest()..mergeFromBuffer(data, registry);
  factory ClawbackCommissionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClawbackCommissionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClawbackCommissionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ClawbackCommissionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'commissionId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'amount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClawbackCommissionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClawbackCommissionRequest copyWith(
          void Function(ClawbackCommissionRequest) updates) =>
      super.copyWith((message) => updates(message as ClawbackCommissionRequest))
          as ClawbackCommissionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClawbackCommissionRequest() / ClawbackCommissionRequest.new instead')
  static ClawbackCommissionRequest create() => ClawbackCommissionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ClawbackCommissionRequest._();
  @$core.override
  ClawbackCommissionRequest createEmptyInstance() =>
      ClawbackCommissionRequest._();
  @$core.pragma('dart2js:noInline')
  static ClawbackCommissionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClawbackCommissionRequest>(
          ClawbackCommissionRequest.$_createMessage);
  static ClawbackCommissionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commissionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set commissionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommissionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get amount => $_getSZ(3);
  @$pb.TagNumber(4)
  set amount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);
}

class ClawbackCommissionResponse extends $pb.GeneratedMessage {
  factory ClawbackCommissionResponse({
    AffiliateCommission? commission,
  }) {
    final result = ClawbackCommissionResponse._();
    if (commission != null) result.commission = commission;
    return result;
  }

  ClawbackCommissionResponse._();

  factory ClawbackCommissionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClawbackCommissionResponse()..mergeFromBuffer(data, registry);
  factory ClawbackCommissionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClawbackCommissionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClawbackCommissionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ClawbackCommissionResponse.$_createMessage)
    ..aOM<AffiliateCommission>(1, _omitFieldNames ? '' : 'commission',
        subBuilder: AffiliateCommission.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClawbackCommissionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClawbackCommissionResponse copyWith(
          void Function(ClawbackCommissionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ClawbackCommissionResponse))
          as ClawbackCommissionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClawbackCommissionResponse() / ClawbackCommissionResponse.new instead')
  static ClawbackCommissionResponse create() => ClawbackCommissionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ClawbackCommissionResponse._();
  @$core.override
  ClawbackCommissionResponse createEmptyInstance() =>
      ClawbackCommissionResponse._();
  @$core.pragma('dart2js:noInline')
  static ClawbackCommissionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClawbackCommissionResponse>(
          ClawbackCommissionResponse.$_createMessage);
  static ClawbackCommissionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateCommission get commission => $_getN(0);
  @$pb.TagNumber(1)
  set commission(AffiliateCommission value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCommission() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommission() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateCommission ensureCommission() => $_ensure(0);
}

class ListCommissionsRequest extends $pb.GeneratedMessage {
  factory ListCommissionsRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    CommissionStatus? status,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = ListCommissionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (status != null) result.status = status;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListCommissionsRequest._();

  factory ListCommissionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommissionsRequest()..mergeFromBuffer(data, registry);
  factory ListCommissionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommissionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommissionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListCommissionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aE<CommissionStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: CommissionStatus.values)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommissionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommissionsRequest copyWith(
          void Function(ListCommissionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCommissionsRequest))
          as ListCommissionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommissionsRequest() / ListCommissionsRequest.new instead')
  static ListCommissionsRequest create() => ListCommissionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCommissionsRequest._();
  @$core.override
  ListCommissionsRequest createEmptyInstance() => ListCommissionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCommissionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommissionsRequest>(
          ListCommissionsRequest.$_createMessage);
  static ListCommissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);

  @$pb.TagNumber(3)
  CommissionStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(CommissionStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);
}

class ListCommissionsResponse extends $pb.GeneratedMessage {
  factory ListCommissionsResponse({
    $core.Iterable<AffiliateCommission>? commissions,
    $core.String? nextPageToken,
  }) {
    final result = ListCommissionsResponse._();
    if (commissions != null) result.commissions.addAll(commissions);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListCommissionsResponse._();

  factory ListCommissionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommissionsResponse()..mergeFromBuffer(data, registry);
  factory ListCommissionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommissionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommissionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListCommissionsResponse.$_createMessage)
    ..pPM<AffiliateCommission>(1, _omitFieldNames ? '' : 'commissions',
        subBuilder: AffiliateCommission.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommissionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommissionsResponse copyWith(
          void Function(ListCommissionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListCommissionsResponse))
          as ListCommissionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommissionsResponse() / ListCommissionsResponse.new instead')
  static ListCommissionsResponse create() => ListCommissionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListCommissionsResponse._();
  @$core.override
  ListCommissionsResponse createEmptyInstance() => ListCommissionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCommissionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommissionsResponse>(
          ListCommissionsResponse.$_createMessage);
  static ListCommissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AffiliateCommission> get commissions => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class PostCommissionToLedgerRequest extends $pb.GeneratedMessage {
  factory PostCommissionToLedgerRequest({
    $core.String? workspaceId,
    $core.String? commissionId,
    WorkspaceEconomicRole? economicRole,
  }) {
    final result = PostCommissionToLedgerRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (commissionId != null) result.commissionId = commissionId;
    if (economicRole != null) result.economicRole = economicRole;
    return result;
  }

  PostCommissionToLedgerRequest._();

  factory PostCommissionToLedgerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostCommissionToLedgerRequest()..mergeFromBuffer(data, registry);
  factory PostCommissionToLedgerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostCommissionToLedgerRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostCommissionToLedgerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PostCommissionToLedgerRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'commissionId')
    ..aE<WorkspaceEconomicRole>(3, _omitFieldNames ? '' : 'economicRole',
        enumValues: WorkspaceEconomicRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostCommissionToLedgerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostCommissionToLedgerRequest copyWith(
          void Function(PostCommissionToLedgerRequest) updates) =>
      super.copyWith(
              (message) => updates(message as PostCommissionToLedgerRequest))
          as PostCommissionToLedgerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PostCommissionToLedgerRequest() / PostCommissionToLedgerRequest.new instead')
  static PostCommissionToLedgerRequest create() =>
      PostCommissionToLedgerRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      PostCommissionToLedgerRequest._();
  @$core.override
  PostCommissionToLedgerRequest createEmptyInstance() =>
      PostCommissionToLedgerRequest._();
  @$core.pragma('dart2js:noInline')
  static PostCommissionToLedgerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostCommissionToLedgerRequest>(
          PostCommissionToLedgerRequest.$_createMessage);
  static PostCommissionToLedgerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commissionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set commissionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommissionId() => $_clearField(2);

  @$pb.TagNumber(3)
  WorkspaceEconomicRole get economicRole => $_getN(2);
  @$pb.TagNumber(3)
  set economicRole(WorkspaceEconomicRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEconomicRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearEconomicRole() => $_clearField(3);
}

class PostCommissionToLedgerResponse extends $pb.GeneratedMessage {
  factory PostCommissionToLedgerResponse({
    LedgerAffiliatePostingResult? result,
  }) {
    final result$ = PostCommissionToLedgerResponse._();
    if (result != null) result$.result = result;
    return result$;
  }

  PostCommissionToLedgerResponse._();

  factory PostCommissionToLedgerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostCommissionToLedgerResponse()..mergeFromBuffer(data, registry);
  factory PostCommissionToLedgerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostCommissionToLedgerResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostCommissionToLedgerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PostCommissionToLedgerResponse.$_createMessage)
    ..aOM<LedgerAffiliatePostingResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: LedgerAffiliatePostingResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostCommissionToLedgerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostCommissionToLedgerResponse copyWith(
          void Function(PostCommissionToLedgerResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PostCommissionToLedgerResponse))
          as PostCommissionToLedgerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PostCommissionToLedgerResponse() / PostCommissionToLedgerResponse.new instead')
  static PostCommissionToLedgerResponse create() =>
      PostCommissionToLedgerResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      PostCommissionToLedgerResponse._();
  @$core.override
  PostCommissionToLedgerResponse createEmptyInstance() =>
      PostCommissionToLedgerResponse._();
  @$core.pragma('dart2js:noInline')
  static PostCommissionToLedgerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostCommissionToLedgerResponse>(
          PostCommissionToLedgerResponse.$_createMessage);
  static PostCommissionToLedgerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LedgerAffiliatePostingResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(LedgerAffiliatePostingResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  LedgerAffiliatePostingResult ensureResult() => $_ensure(0);
}

class CreatePayoutBatchRequest extends $pb.GeneratedMessage {
  factory CreatePayoutBatchRequest({
    $core.String? workspaceId,
    $core.String? creatorEntityId,
    $core.Iterable<$core.String>? commissionIds,
  }) {
    final result = CreatePayoutBatchRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (commissionIds != null) result.commissionIds.addAll(commissionIds);
    return result;
  }

  CreatePayoutBatchRequest._();

  factory CreatePayoutBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePayoutBatchRequest()..mergeFromBuffer(data, registry);
  factory CreatePayoutBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePayoutBatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePayoutBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreatePayoutBatchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'creatorEntityId')
    ..pPS(3, _omitFieldNames ? '' : 'commissionIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePayoutBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePayoutBatchRequest copyWith(
          void Function(CreatePayoutBatchRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePayoutBatchRequest))
          as CreatePayoutBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreatePayoutBatchRequest() / CreatePayoutBatchRequest.new instead')
  static CreatePayoutBatchRequest create() => CreatePayoutBatchRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreatePayoutBatchRequest._();
  @$core.override
  CreatePayoutBatchRequest createEmptyInstance() =>
      CreatePayoutBatchRequest._();
  @$core.pragma('dart2js:noInline')
  static CreatePayoutBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePayoutBatchRequest>(
          CreatePayoutBatchRequest.$_createMessage);
  static CreatePayoutBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creatorEntityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set creatorEntityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatorEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatorEntityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get commissionIds => $_getList(2);
}

class CreatePayoutBatchResponse extends $pb.GeneratedMessage {
  factory CreatePayoutBatchResponse({
    AffiliatePayout? payout,
  }) {
    final result = CreatePayoutBatchResponse._();
    if (payout != null) result.payout = payout;
    return result;
  }

  CreatePayoutBatchResponse._();

  factory CreatePayoutBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePayoutBatchResponse()..mergeFromBuffer(data, registry);
  factory CreatePayoutBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePayoutBatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePayoutBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreatePayoutBatchResponse.$_createMessage)
    ..aOM<AffiliatePayout>(1, _omitFieldNames ? '' : 'payout',
        subBuilder: AffiliatePayout.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePayoutBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePayoutBatchResponse copyWith(
          void Function(CreatePayoutBatchResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePayoutBatchResponse))
          as CreatePayoutBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreatePayoutBatchResponse() / CreatePayoutBatchResponse.new instead')
  static CreatePayoutBatchResponse create() => CreatePayoutBatchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreatePayoutBatchResponse._();
  @$core.override
  CreatePayoutBatchResponse createEmptyInstance() =>
      CreatePayoutBatchResponse._();
  @$core.pragma('dart2js:noInline')
  static CreatePayoutBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePayoutBatchResponse>(
          CreatePayoutBatchResponse.$_createMessage);
  static CreatePayoutBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliatePayout get payout => $_getN(0);
  @$pb.TagNumber(1)
  set payout(AffiliatePayout value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayout() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliatePayout ensurePayout() => $_ensure(0);
}

class ExecutePayoutBatchRequest extends $pb.GeneratedMessage {
  factory ExecutePayoutBatchRequest({
    $core.String? workspaceId,
    $core.String? payoutId,
    $core.String? settlementId,
  }) {
    final result = ExecutePayoutBatchRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (payoutId != null) result.payoutId = payoutId;
    if (settlementId != null) result.settlementId = settlementId;
    return result;
  }

  ExecutePayoutBatchRequest._();

  factory ExecutePayoutBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecutePayoutBatchRequest()..mergeFromBuffer(data, registry);
  factory ExecutePayoutBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecutePayoutBatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecutePayoutBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ExecutePayoutBatchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'payoutId')
    ..aOS(3, _omitFieldNames ? '' : 'settlementId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutePayoutBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutePayoutBatchRequest copyWith(
          void Function(ExecutePayoutBatchRequest) updates) =>
      super.copyWith((message) => updates(message as ExecutePayoutBatchRequest))
          as ExecutePayoutBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecutePayoutBatchRequest() / ExecutePayoutBatchRequest.new instead')
  static ExecutePayoutBatchRequest create() => ExecutePayoutBatchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecutePayoutBatchRequest._();
  @$core.override
  ExecutePayoutBatchRequest createEmptyInstance() =>
      ExecutePayoutBatchRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecutePayoutBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecutePayoutBatchRequest>(
          ExecutePayoutBatchRequest.$_createMessage);
  static ExecutePayoutBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get payoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set payoutId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get settlementId => $_getSZ(2);
  @$pb.TagNumber(3)
  set settlementId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettlementId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettlementId() => $_clearField(3);
}

class ExecutePayoutBatchResponse extends $pb.GeneratedMessage {
  factory ExecutePayoutBatchResponse({
    AffiliatePayout? payout,
  }) {
    final result = ExecutePayoutBatchResponse._();
    if (payout != null) result.payout = payout;
    return result;
  }

  ExecutePayoutBatchResponse._();

  factory ExecutePayoutBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecutePayoutBatchResponse()..mergeFromBuffer(data, registry);
  factory ExecutePayoutBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecutePayoutBatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecutePayoutBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ExecutePayoutBatchResponse.$_createMessage)
    ..aOM<AffiliatePayout>(1, _omitFieldNames ? '' : 'payout',
        subBuilder: AffiliatePayout.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutePayoutBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutePayoutBatchResponse copyWith(
          void Function(ExecutePayoutBatchResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExecutePayoutBatchResponse))
          as ExecutePayoutBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecutePayoutBatchResponse() / ExecutePayoutBatchResponse.new instead')
  static ExecutePayoutBatchResponse create() => ExecutePayoutBatchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecutePayoutBatchResponse._();
  @$core.override
  ExecutePayoutBatchResponse createEmptyInstance() =>
      ExecutePayoutBatchResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecutePayoutBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecutePayoutBatchResponse>(
          ExecutePayoutBatchResponse.$_createMessage);
  static ExecutePayoutBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliatePayout get payout => $_getN(0);
  @$pb.TagNumber(1)
  set payout(AffiliatePayout value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayout() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliatePayout ensurePayout() => $_ensure(0);
}

class GetPayoutProofRequest extends $pb.GeneratedMessage {
  factory GetPayoutProofRequest({
    $core.String? workspaceId,
    $core.String? payoutId,
  }) {
    final result = GetPayoutProofRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (payoutId != null) result.payoutId = payoutId;
    return result;
  }

  GetPayoutProofRequest._();

  factory GetPayoutProofRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPayoutProofRequest()..mergeFromBuffer(data, registry);
  factory GetPayoutProofRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPayoutProofRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPayoutProofRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPayoutProofRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'payoutId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPayoutProofRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPayoutProofRequest copyWith(
          void Function(GetPayoutProofRequest) updates) =>
      super.copyWith((message) => updates(message as GetPayoutProofRequest))
          as GetPayoutProofRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPayoutProofRequest() / GetPayoutProofRequest.new instead')
  static GetPayoutProofRequest create() => GetPayoutProofRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPayoutProofRequest._();
  @$core.override
  GetPayoutProofRequest createEmptyInstance() => GetPayoutProofRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPayoutProofRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPayoutProofRequest>(
          GetPayoutProofRequest.$_createMessage);
  static GetPayoutProofRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get payoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set payoutId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayoutId() => $_clearField(2);
}

class GetPayoutProofResponse extends $pb.GeneratedMessage {
  factory GetPayoutProofResponse({
    AffiliatePayout? payout,
    $core.String? proofHash,
    $core.String? proofUrl,
  }) {
    final result = GetPayoutProofResponse._();
    if (payout != null) result.payout = payout;
    if (proofHash != null) result.proofHash = proofHash;
    if (proofUrl != null) result.proofUrl = proofUrl;
    return result;
  }

  GetPayoutProofResponse._();

  factory GetPayoutProofResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPayoutProofResponse()..mergeFromBuffer(data, registry);
  factory GetPayoutProofResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPayoutProofResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPayoutProofResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPayoutProofResponse.$_createMessage)
    ..aOM<AffiliatePayout>(1, _omitFieldNames ? '' : 'payout',
        subBuilder: AffiliatePayout.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'proofHash')
    ..aOS(3, _omitFieldNames ? '' : 'proofUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPayoutProofResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPayoutProofResponse copyWith(
          void Function(GetPayoutProofResponse) updates) =>
      super.copyWith((message) => updates(message as GetPayoutProofResponse))
          as GetPayoutProofResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPayoutProofResponse() / GetPayoutProofResponse.new instead')
  static GetPayoutProofResponse create() => GetPayoutProofResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPayoutProofResponse._();
  @$core.override
  GetPayoutProofResponse createEmptyInstance() => GetPayoutProofResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPayoutProofResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPayoutProofResponse>(
          GetPayoutProofResponse.$_createMessage);
  static GetPayoutProofResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliatePayout get payout => $_getN(0);
  @$pb.TagNumber(1)
  set payout(AffiliatePayout value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayout() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliatePayout ensurePayout() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get proofHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set proofHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProofHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearProofHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get proofUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set proofUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProofUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearProofUrl() => $_clearField(3);
}

class ImportStatementRequest extends $pb.GeneratedMessage {
  factory ImportStatementRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.String? externalStatementRef,
    $core.String? periodStart,
    $core.String? periodEnd,
    $core.String? currency,
    $core.Iterable<AffiliateStatementItem>? items,
  }) {
    final result = ImportStatementRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (externalStatementRef != null)
      result.externalStatementRef = externalStatementRef;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (currency != null) result.currency = currency;
    if (items != null) result.items.addAll(items);
    return result;
  }

  ImportStatementRequest._();

  factory ImportStatementRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportStatementRequest()..mergeFromBuffer(data, registry);
  factory ImportStatementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportStatementRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportStatementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ImportStatementRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'externalStatementRef')
    ..aOS(4, _omitFieldNames ? '' : 'periodStart')
    ..aOS(5, _omitFieldNames ? '' : 'periodEnd')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..pPM<AffiliateStatementItem>(7, _omitFieldNames ? '' : 'items',
        subBuilder: AffiliateStatementItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportStatementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportStatementRequest copyWith(
          void Function(ImportStatementRequest) updates) =>
      super.copyWith((message) => updates(message as ImportStatementRequest))
          as ImportStatementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ImportStatementRequest() / ImportStatementRequest.new instead')
  static ImportStatementRequest create() => ImportStatementRequest._();
  static $pb.GeneratedMessage $_createMessage() => ImportStatementRequest._();
  @$core.override
  ImportStatementRequest createEmptyInstance() => ImportStatementRequest._();
  @$core.pragma('dart2js:noInline')
  static ImportStatementRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportStatementRequest>(
          ImportStatementRequest.$_createMessage);
  static ImportStatementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get externalStatementRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set externalStatementRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExternalStatementRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalStatementRef() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get periodStart => $_getSZ(3);
  @$pb.TagNumber(4)
  set periodStart($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodEnd => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodEnd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodEnd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<AffiliateStatementItem> get items => $_getList(6);
}

class ImportStatementResponse extends $pb.GeneratedMessage {
  factory ImportStatementResponse({
    AffiliateStatement? statement,
  }) {
    final result = ImportStatementResponse._();
    if (statement != null) result.statement = statement;
    return result;
  }

  ImportStatementResponse._();

  factory ImportStatementResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportStatementResponse()..mergeFromBuffer(data, registry);
  factory ImportStatementResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportStatementResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportStatementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ImportStatementResponse.$_createMessage)
    ..aOM<AffiliateStatement>(1, _omitFieldNames ? '' : 'statement',
        subBuilder: AffiliateStatement.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportStatementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportStatementResponse copyWith(
          void Function(ImportStatementResponse) updates) =>
      super.copyWith((message) => updates(message as ImportStatementResponse))
          as ImportStatementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ImportStatementResponse() / ImportStatementResponse.new instead')
  static ImportStatementResponse create() => ImportStatementResponse._();
  static $pb.GeneratedMessage $_createMessage() => ImportStatementResponse._();
  @$core.override
  ImportStatementResponse createEmptyInstance() => ImportStatementResponse._();
  @$core.pragma('dart2js:noInline')
  static ImportStatementResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportStatementResponse>(
          ImportStatementResponse.$_createMessage);
  static ImportStatementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateStatement get statement => $_getN(0);
  @$pb.TagNumber(1)
  set statement(AffiliateStatement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatement() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatement() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateStatement ensureStatement() => $_ensure(0);
}

class ReconcileStatementRequest extends $pb.GeneratedMessage {
  factory ReconcileStatementRequest({
    $core.String? workspaceId,
    $core.String? statementId,
  }) {
    final result = ReconcileStatementRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (statementId != null) result.statementId = statementId;
    return result;
  }

  ReconcileStatementRequest._();

  factory ReconcileStatementRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileStatementRequest()..mergeFromBuffer(data, registry);
  factory ReconcileStatementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileStatementRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileStatementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ReconcileStatementRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'statementId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileStatementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileStatementRequest copyWith(
          void Function(ReconcileStatementRequest) updates) =>
      super.copyWith((message) => updates(message as ReconcileStatementRequest))
          as ReconcileStatementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcileStatementRequest() / ReconcileStatementRequest.new instead')
  static ReconcileStatementRequest create() => ReconcileStatementRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconcileStatementRequest._();
  @$core.override
  ReconcileStatementRequest createEmptyInstance() =>
      ReconcileStatementRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconcileStatementRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileStatementRequest>(
          ReconcileStatementRequest.$_createMessage);
  static ReconcileStatementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get statementId => $_getSZ(1);
  @$pb.TagNumber(2)
  set statementId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatementId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatementId() => $_clearField(2);
}

class ReconcileStatementResponse extends $pb.GeneratedMessage {
  factory ReconcileStatementResponse({
    AffiliateStatement? statement,
    $core.int? matchedCount,
    $core.int? conflictCount,
    $core.int? unreconciledCount,
  }) {
    final result = ReconcileStatementResponse._();
    if (statement != null) result.statement = statement;
    if (matchedCount != null) result.matchedCount = matchedCount;
    if (conflictCount != null) result.conflictCount = conflictCount;
    if (unreconciledCount != null) result.unreconciledCount = unreconciledCount;
    return result;
  }

  ReconcileStatementResponse._();

  factory ReconcileStatementResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileStatementResponse()..mergeFromBuffer(data, registry);
  factory ReconcileStatementResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileStatementResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileStatementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ReconcileStatementResponse.$_createMessage)
    ..aOM<AffiliateStatement>(1, _omitFieldNames ? '' : 'statement',
        subBuilder: AffiliateStatement.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'matchedCount')
    ..aI(3, _omitFieldNames ? '' : 'conflictCount')
    ..aI(4, _omitFieldNames ? '' : 'unreconciledCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileStatementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileStatementResponse copyWith(
          void Function(ReconcileStatementResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReconcileStatementResponse))
          as ReconcileStatementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcileStatementResponse() / ReconcileStatementResponse.new instead')
  static ReconcileStatementResponse create() => ReconcileStatementResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconcileStatementResponse._();
  @$core.override
  ReconcileStatementResponse createEmptyInstance() =>
      ReconcileStatementResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconcileStatementResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileStatementResponse>(
          ReconcileStatementResponse.$_createMessage);
  static ReconcileStatementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateStatement get statement => $_getN(0);
  @$pb.TagNumber(1)
  set statement(AffiliateStatement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatement() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatement() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateStatement ensureStatement() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get matchedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set matchedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get conflictCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set conflictCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConflictCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearConflictCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unreconciledCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreconciledCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreconciledCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreconciledCount() => $_clearField(4);
}

class RunHealthCheckRequest extends $pb.GeneratedMessage {
  factory RunHealthCheckRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.int? simulatedHttpStatus,
    $core.String? simulatedProductStatus,
    $core.String? simulatedCommissionRate,
  }) {
    final result = RunHealthCheckRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (simulatedHttpStatus != null)
      result.simulatedHttpStatus = simulatedHttpStatus;
    if (simulatedProductStatus != null)
      result.simulatedProductStatus = simulatedProductStatus;
    if (simulatedCommissionRate != null)
      result.simulatedCommissionRate = simulatedCommissionRate;
    return result;
  }

  RunHealthCheckRequest._();

  factory RunHealthCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunHealthCheckRequest()..mergeFromBuffer(data, registry);
  factory RunHealthCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunHealthCheckRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunHealthCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RunHealthCheckRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aI(3, _omitFieldNames ? '' : 'simulatedHttpStatus')
    ..aOS(4, _omitFieldNames ? '' : 'simulatedProductStatus')
    ..aOS(5, _omitFieldNames ? '' : 'simulatedCommissionRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunHealthCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunHealthCheckRequest copyWith(
          void Function(RunHealthCheckRequest) updates) =>
      super.copyWith((message) => updates(message as RunHealthCheckRequest))
          as RunHealthCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RunHealthCheckRequest() / RunHealthCheckRequest.new instead')
  static RunHealthCheckRequest create() => RunHealthCheckRequest._();
  static $pb.GeneratedMessage $_createMessage() => RunHealthCheckRequest._();
  @$core.override
  RunHealthCheckRequest createEmptyInstance() => RunHealthCheckRequest._();
  @$core.pragma('dart2js:noInline')
  static RunHealthCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunHealthCheckRequest>(
          RunHealthCheckRequest.$_createMessage);
  static RunHealthCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get simulatedHttpStatus => $_getIZ(2);
  @$pb.TagNumber(3)
  set simulatedHttpStatus($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSimulatedHttpStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearSimulatedHttpStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get simulatedProductStatus => $_getSZ(3);
  @$pb.TagNumber(4)
  set simulatedProductStatus($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSimulatedProductStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearSimulatedProductStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get simulatedCommissionRate => $_getSZ(4);
  @$pb.TagNumber(5)
  set simulatedCommissionRate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSimulatedCommissionRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearSimulatedCommissionRate() => $_clearField(5);
}

class RunHealthCheckResponse extends $pb.GeneratedMessage {
  factory RunHealthCheckResponse({
    LinkHealthRecord? health,
    $core.bool? healthDegraded,
  }) {
    final result = RunHealthCheckResponse._();
    if (health != null) result.health = health;
    if (healthDegraded != null) result.healthDegraded = healthDegraded;
    return result;
  }

  RunHealthCheckResponse._();

  factory RunHealthCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunHealthCheckResponse()..mergeFromBuffer(data, registry);
  factory RunHealthCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunHealthCheckResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunHealthCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RunHealthCheckResponse.$_createMessage)
    ..aOM<LinkHealthRecord>(1, _omitFieldNames ? '' : 'health',
        subBuilder: LinkHealthRecord.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'healthDegraded')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunHealthCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunHealthCheckResponse copyWith(
          void Function(RunHealthCheckResponse) updates) =>
      super.copyWith((message) => updates(message as RunHealthCheckResponse))
          as RunHealthCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RunHealthCheckResponse() / RunHealthCheckResponse.new instead')
  static RunHealthCheckResponse create() => RunHealthCheckResponse._();
  static $pb.GeneratedMessage $_createMessage() => RunHealthCheckResponse._();
  @$core.override
  RunHealthCheckResponse createEmptyInstance() => RunHealthCheckResponse._();
  @$core.pragma('dart2js:noInline')
  static RunHealthCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunHealthCheckResponse>(
          RunHealthCheckResponse.$_createMessage);
  static RunHealthCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkHealthRecord get health => $_getN(0);
  @$pb.TagNumber(1)
  set health(LinkHealthRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHealth() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealth() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkHealthRecord ensureHealth() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get healthDegraded => $_getBF(1);
  @$pb.TagNumber(2)
  set healthDegraded($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHealthDegraded() => $_has(1);
  @$pb.TagNumber(2)
  void clearHealthDegraded() => $_clearField(2);
}

class RepairBrokenLinkRequest extends $pb.GeneratedMessage {
  factory RepairBrokenLinkRequest({
    $core.String? workspaceId,
    $core.String? affiliateLinkId,
    $core.String? newDestinationUrl,
    $core.String? replacementProductId,
  }) {
    final result = RepairBrokenLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (affiliateLinkId != null) result.affiliateLinkId = affiliateLinkId;
    if (newDestinationUrl != null) result.newDestinationUrl = newDestinationUrl;
    if (replacementProductId != null)
      result.replacementProductId = replacementProductId;
    return result;
  }

  RepairBrokenLinkRequest._();

  factory RepairBrokenLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RepairBrokenLinkRequest()..mergeFromBuffer(data, registry);
  factory RepairBrokenLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RepairBrokenLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RepairBrokenLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RepairBrokenLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'affiliateLinkId')
    ..aOS(3, _omitFieldNames ? '' : 'newDestinationUrl')
    ..aOS(4, _omitFieldNames ? '' : 'replacementProductId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RepairBrokenLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RepairBrokenLinkRequest copyWith(
          void Function(RepairBrokenLinkRequest) updates) =>
      super.copyWith((message) => updates(message as RepairBrokenLinkRequest))
          as RepairBrokenLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RepairBrokenLinkRequest() / RepairBrokenLinkRequest.new instead')
  static RepairBrokenLinkRequest create() => RepairBrokenLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => RepairBrokenLinkRequest._();
  @$core.override
  RepairBrokenLinkRequest createEmptyInstance() => RepairBrokenLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static RepairBrokenLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RepairBrokenLinkRequest>(
          RepairBrokenLinkRequest.$_createMessage);
  static RepairBrokenLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get affiliateLinkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set affiliateLinkId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAffiliateLinkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAffiliateLinkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newDestinationUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set newDestinationUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewDestinationUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewDestinationUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get replacementProductId => $_getSZ(3);
  @$pb.TagNumber(4)
  set replacementProductId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReplacementProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReplacementProductId() => $_clearField(4);
}

class RepairBrokenLinkResponse extends $pb.GeneratedMessage {
  factory RepairBrokenLinkResponse({
    AffiliateLink? link,
    LinkHealthRecord? health,
  }) {
    final result = RepairBrokenLinkResponse._();
    if (link != null) result.link = link;
    if (health != null) result.health = health;
    return result;
  }

  RepairBrokenLinkResponse._();

  factory RepairBrokenLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RepairBrokenLinkResponse()..mergeFromBuffer(data, registry);
  factory RepairBrokenLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RepairBrokenLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RepairBrokenLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RepairBrokenLinkResponse.$_createMessage)
    ..aOM<AffiliateLink>(1, _omitFieldNames ? '' : 'link',
        subBuilder: AffiliateLink.$_createMessage)
    ..aOM<LinkHealthRecord>(2, _omitFieldNames ? '' : 'health',
        subBuilder: LinkHealthRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RepairBrokenLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RepairBrokenLinkResponse copyWith(
          void Function(RepairBrokenLinkResponse) updates) =>
      super.copyWith((message) => updates(message as RepairBrokenLinkResponse))
          as RepairBrokenLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RepairBrokenLinkResponse() / RepairBrokenLinkResponse.new instead')
  static RepairBrokenLinkResponse create() => RepairBrokenLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => RepairBrokenLinkResponse._();
  @$core.override
  RepairBrokenLinkResponse createEmptyInstance() =>
      RepairBrokenLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static RepairBrokenLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RepairBrokenLinkResponse>(
          RepairBrokenLinkResponse.$_createMessage);
  static RepairBrokenLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AffiliateLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(AffiliateLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  AffiliateLink ensureLink() => $_ensure(0);

  @$pb.TagNumber(2)
  LinkHealthRecord get health => $_getN(1);
  @$pb.TagNumber(2)
  set health(LinkHealthRecord value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHealth() => $_has(1);
  @$pb.TagNumber(2)
  void clearHealth() => $_clearField(2);
  @$pb.TagNumber(2)
  LinkHealthRecord ensureHealth() => $_ensure(1);
}

class GetHealthReportRequest extends $pb.GeneratedMessage {
  factory GetHealthReportRequest({
    $core.String? workspaceId,
  }) {
    final result = GetHealthReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetHealthReportRequest._();

  factory GetHealthReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthReportRequest()..mergeFromBuffer(data, registry);
  factory GetHealthReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetHealthReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthReportRequest copyWith(
          void Function(GetHealthReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetHealthReportRequest))
          as GetHealthReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthReportRequest() / GetHealthReportRequest.new instead')
  static GetHealthReportRequest create() => GetHealthReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthReportRequest._();
  @$core.override
  GetHealthReportRequest createEmptyInstance() => GetHealthReportRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHealthReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthReportRequest>(
          GetHealthReportRequest.$_createMessage);
  static GetHealthReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetHealthReportResponse extends $pb.GeneratedMessage {
  factory GetHealthReportResponse({
    $core.Iterable<LinkHealthRecord>? healthRecords,
    $core.int? healthyCount,
    $core.int? warningCount,
    $core.int? brokenCount,
    $core.String? totalRevenueAtRisk,
  }) {
    final result = GetHealthReportResponse._();
    if (healthRecords != null) result.healthRecords.addAll(healthRecords);
    if (healthyCount != null) result.healthyCount = healthyCount;
    if (warningCount != null) result.warningCount = warningCount;
    if (brokenCount != null) result.brokenCount = brokenCount;
    if (totalRevenueAtRisk != null)
      result.totalRevenueAtRisk = totalRevenueAtRisk;
    return result;
  }

  GetHealthReportResponse._();

  factory GetHealthReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthReportResponse()..mergeFromBuffer(data, registry);
  factory GetHealthReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetHealthReportResponse.$_createMessage)
    ..pPM<LinkHealthRecord>(1, _omitFieldNames ? '' : 'healthRecords',
        subBuilder: LinkHealthRecord.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'healthyCount')
    ..aI(3, _omitFieldNames ? '' : 'warningCount')
    ..aI(4, _omitFieldNames ? '' : 'brokenCount')
    ..aOS(5, _omitFieldNames ? '' : 'totalRevenueAtRisk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthReportResponse copyWith(
          void Function(GetHealthReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetHealthReportResponse))
          as GetHealthReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthReportResponse() / GetHealthReportResponse.new instead')
  static GetHealthReportResponse create() => GetHealthReportResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthReportResponse._();
  @$core.override
  GetHealthReportResponse createEmptyInstance() => GetHealthReportResponse._();
  @$core.pragma('dart2js:noInline')
  static GetHealthReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthReportResponse>(
          GetHealthReportResponse.$_createMessage);
  static GetHealthReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LinkHealthRecord> get healthRecords => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get healthyCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set healthyCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHealthyCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearHealthyCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get warningCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set warningCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWarningCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearWarningCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get brokenCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set brokenCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBrokenCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearBrokenCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get totalRevenueAtRisk => $_getSZ(4);
  @$pb.TagNumber(5)
  set totalRevenueAtRisk($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalRevenueAtRisk() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalRevenueAtRisk() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
