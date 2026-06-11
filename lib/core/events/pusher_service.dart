import 'dart:developer';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  // A callback that we can set from our controller to react to events
  Function(PusherEvent)? onEventReceived;

  Future<void> init() async {
    try {
      await pusher.init(
        apiKey: "1d204167529f719495e4",
        cluster: "mt1",
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );
      await pusher.connect();
      log("Pusher initialized and connected.");
    } catch (e) {
      log("Pusher ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Pusher Connection State: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("Pusher Error: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    log("Pusher Event: ${event.eventName} data: ${event.data}");
    if (onEventReceived != null) {
      onEventReceived!(event);
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("Pusher Subscription Succeeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("Pusher Subscription Error: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("Pusher Decryption Failure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("Pusher Member Added: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("Pusher Member Removed: $channelName user: $member");
  }

  Future<void> subscribe(String channelName) async {
    await pusher.subscribe(channelName: channelName);
    log("Subscribed to $channelName");
  }

  Future<void> unsubscribe(String channelName) async {
    await pusher.unsubscribe(channelName: channelName);
    log("Unsubscribed from $channelName");
  }
}
