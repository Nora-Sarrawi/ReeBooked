class SwapNotificationSummary {
  final String swapId;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final String lastMessage;
  final DateTime lastTimestamp;
  final int unreadCount;

  SwapNotificationSummary({
    required this.swapId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.unreadCount,
  });
}
