import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/notification_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'seller_order':
        return Icons.monetization_on_outlined;
      case 'buyer_order':
        return Icons.shopping_bag_outlined;
      case 'payment_verified':
        return Icons.verified_user_outlined;
      case 'cart_added':
        return Icons.shopping_cart_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _colorForType(String? type) {
    switch (type) {
      case 'seller_order':
        return Colors.green;
      case 'buyer_order':
        return AppColors.primaryColor;
      case 'payment_verified':
        return Colors.teal;
      case 'cart_added':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notifProvider = context.watch<NotificationProvider>();
    final productProvider = context.watch<ProductProvider>();
    
    final notifications = notifProvider.notifications;
    final hasMyProducts = auth.isAuthenticated &&
        productProvider.products.any((p) => p.user == auth.currentUser?.id);

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Color(0xff00113A)),
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00113A),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xff00113A)),
                    onSelected: (val) {
                      if (val == 'read') {
                        notifProvider.markAllAsRead();
                      } else if (val == 'clear') {
                        notifProvider.clearAll();
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_chat_read_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Mark all as read'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clear',
                        child: Row(
                          children: [
                            Icon(Icons.delete_sweep_outlined, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Clear all', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Seller Sandbox Controls ────────────────────
              if (auth.isAuthenticated && hasMyProducts)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seller Simulation Sandbox',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff00113A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Test notification triggers for orders placed on your products.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          notifProvider.triggerManualSellerOrderSimulation(
                            productProvider.products,
                            auth.currentUser!.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Simulated buyer purchase on your product!'),
                            backgroundColor: Colors.green,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: const Text('Simulate', style: TextStyle(fontSize: 12)),
                      )
                    ],
                  ),
                ),

              // ── Notifications List ──────────────────────────
              Expanded(
                child: notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, idx) {
                          final notif = notifications[idx];
                          return Dismissible(
                            key: Key(notif.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              notifProvider.deleteNotification(notif.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Notification deleted'),
                                duration: Duration(seconds: 1),
                              ));
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (!notif.isRead) {
                                  notifProvider.markAsRead(notif.id);
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: notif.isRead ? Colors.white : const Color(0xffF0F3FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: notif.isRead
                                        ? Colors.white
                                        : AppColors.primaryColor.withOpacity(0.15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Icon
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: _colorForType(notif.type).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _iconForType(notif.type),
                                        color: _colorForType(notif.type),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notif.title,
                                                  style: TextStyle(
                                                    fontWeight: notif.isRead
                                                        ? FontWeight.bold
                                                        : FontWeight.w900,
                                                    fontSize: 14,
                                                    color: const Color(0xff00113A),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _formatTime(notif.timestamp),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            notif.body,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!notif.isRead) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff00113A)),
          ),
          const SizedBox(height: 8),
          Text(
            'You will receive notifications here\nwhen orders are placed or processed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
