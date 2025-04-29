import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/model/media.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    this.onConfirmTransaction,
    this.isNewMessage = false,
  }) : super(key: key);

  final Message message;
  final Function(int, String)? onConfirmTransaction;
  final bool isNewMessage;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, bool> _isPlayingMap = {};
  final Map<String, Duration> _audioPositions = {};
  final Map<String, StreamSubscription<Duration>> _positionSubscriptions = {};
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  final ValueNotifier<double> _confirmedAmountNotifier =
      ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();

    // Setup entrance animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutBack,
    );

    if (widget.isNewMessage) {
      _animationController!.forward();
    } else {
      _animationController!.value = 1.0;
    }

    // Initialize audio positions
    for (var media in widget.message.medias) {
      if (media.type.toLowerCase().contains('audio')) {
        _isPlayingMap[media.id] = false;
        _audioPositions[media.id] = Duration.zero;
      }
    }

    // Setup audio player listeners
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          for (var key in _isPlayingMap.keys) {
            _isPlayingMap[key] = false;
          }
        });
      }
    });

    _calculateConfirmedAmount();

    double initialConfirmedAmount = 0.0;
    for (var transaction in widget.message.extractedTransactions) {
      if (transaction.confirmationStatus == 'Confirmed') {
        double amount = transaction.type == 'Expense'
            ? -transaction.amount
            : transaction.amount;
        initialConfirmedAmount += amount;
      }
    }
    _confirmedAmountNotifier.value = initialConfirmedAmount;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController?.dispose();
    for (var subscription in _positionSubscriptions.values) {
      subscription.cancel();
    }
    _confirmedAmountNotifier.dispose();

    super.dispose();
  }

  void _calculateConfirmedAmount() {
    double confirmedAmount = 0.0;
    for (var transaction in widget.message.extractedTransactions) {
      if (transaction.confirmationStatus == 'Confirmed') {
        double amount = transaction.type == 'Expense'
            ? -transaction.amount
            : transaction.amount;
        confirmedAmount += amount;
      }
    }
    _confirmedAmountNotifier.value = confirmedAmount;
  }

  @override
  Widget build(BuildContext context) {
    final isUserMessage = widget.message.role.toLowerCase() == "human";

    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Opacity(
          opacity: _scaleAnimation!.value,
          child: Transform.scale(
            scale: _scaleAnimation!.value,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: isUserMessage ? 64.0 : 8.0,
            right: isUserMessage ? 8.0 : 64.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onLongPress: () => _showMessageOptions(context),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    bottomRight:
                        isUserMessage ? const Radius.circular(4) : null,
                    bottomLeft:
                        !isUserMessage ? const Radius.circular(4) : null,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: isUserMessage
                          ? LinearGradient(
                              colors: [
                                ColorName.primaryGradientStart,
                                ColorName.primaryGradientEnd,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isUserMessage
                          ? null
                          : Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2C2C2E)
                              : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight:
                            isUserMessage ? const Radius.circular(4) : null,
                        bottomLeft:
                            !isUserMessage ? const Radius.circular(4) : null,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.message.content.isNotEmpty)
                            MarkdownBody(
                              data: widget.message.content,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  color: isUserMessage
                                      ? Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                  height: 1.4,
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                ),
                                em: TextStyle(
                                  // For italics (*text*)
                                  color: isUserMessage
                                      ? Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                  height: 1.4,
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                  fontStyle: FontStyle.italic,
                                ),
                                strong: TextStyle(
                                  // For bold (**text**)
                                  color: isUserMessage
                                      ? Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                  height: 1.4,
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                ),
                                listIndent: 20.0,
                                orderedListAlign: WrapAlignment.start,
                                listBullet: TextStyle(
                                  color: isUserMessage
                                      ? Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                ),
                                a: TextStyle(
                                  color: isUserMessage
                                      ? Colors.lightBlue[100]
                                      : Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTapLink: (text, href, title) {
                                if (href != null) {
                                  launchUrl(Uri.parse(href));
                                }
                              },
                            ),
                          if (widget.message.medias.isNotEmpty)
                            _buildMediaContent(context),
                          if (widget.message.extractedTransactions.isNotEmpty)
                            _buildExtractedTransactions(context),
                          const SizedBox(height: 6),
                          _buildMessageFooter(isUserMessage),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageFooter(bool isUserMessage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Text(
          DateFormat('HH:mm').format(widget.message.createdAt),
          style: TextStyle(
            color: isUserMessage ? Colors.white70 : Colors.grey[600],
            fontSize: 10,
            fontFamily: 'Nunito',
          ),
        ),
        // if (isUserMessage) ...[
        //   const SizedBox(width: 4),
        //   Icon(
        //     widget.message.status == "read"
        //         ? Icons.done_all
        //         : Icons.done,
        //     size: 12,
        //     color: widget.message.status == "read"
        //         ? Colors.blue[300]
        //         : Colors.white70,
        //   ),
        // ],
      ],
    );
  }

  void _showMessageOptions(BuildContext context) {
    HapticFeedback.mediumImpact();

    final isUserMessage = widget.message.role.toLowerCase() == "user";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text(
                'Copy text',
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.message.content));
                Navigator.pop(context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Message copied to clipboard'),
                //     behavior: SnackBar2Behavior.floating,
                //     duration: Duration(seconds: 1),
                //   ),
                // );
              },
            ),
            // if (isUserMessage)
            //   ListTile(
            //     leading: const Icon(Icons.delete_outline),
            //     title: const Text('Delete message'),
            //     textColor: Colors.red,
            //     iconColor: Colors.red,
            //     onTap: () {
            //       Navigator.pop(context);
            //       // Delete functionality would go here
            //     },
            //   ),
            // ListTile(
            //   leading: const Icon(Icons.reply),
            //   title: const Text('Reply'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Reply functionality would go here
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    if (widget.message.medias.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ...widget.message.medias.map((media) {
          final isAudio = media.type.toLowerCase().contains('audio');

          if (isAudio) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildAudioPlayer(media),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildImageDisplay(context, media),
            );
          }
        }).toList(),
      ],
    );
  }

  Widget _buildImageDisplay(BuildContext context, Media media) {
    final isUserMessage = widget.message.role.toLowerCase() == "user";

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 220,
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        child: GestureDetector(
          onTap: () => _showFullScreenImage(context, media),
          child: Hero(
            tag: media.id,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: media.thumbnailUrl ?? '',
                  placeholder: (context, url) => Container(
                    color: isUserMessage
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.error_outline, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            "Image couldn't be loaded",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Nunito'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
                // Optional play button for videos
                if (media.type.toLowerCase().contains('video'))
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(Media audio) {
    final isUserMessage = widget.message.role.toLowerCase() == "user";

    // Initialize this media's playing status if not already done
    _isPlayingMap[audio.id] ??= false;
    _audioPositions[audio.id] ??= Duration.zero;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isUserMessage
            ? Colors.white.withOpacity(0.15)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUserMessage
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUserMessage
                      ? Colors.white.withOpacity(0.2)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: IconButton(
                  iconSize: 18,
                  icon: Icon(
                    _isPlayingMap[audio.id]!
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: isUserMessage
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (_isPlayingMap[audio.id]!) {
                      await _audioPlayer.pause();
                      setState(() => _isPlayingMap[audio.id] = false);
                    } else {
                      // Stop any currently playing audio first
                      for (var key in _isPlayingMap.keys) {
                        if (_isPlayingMap[key]!) {
                          _isPlayingMap[key] = false;
                        }
                      }

                      await _audioPlayer.play(UrlSource(audio.secureUrl));
                      setState(() => _isPlayingMap[audio.id] = true);

                      // Listen to position changes
                      _positionSubscriptions[audio.id]?.cancel();
                      _positionSubscriptions[audio.id] =
                          _audioPlayer.onPositionChanged.listen((position) {
                        if (mounted) {
                          setState(() {
                            _audioPositions[audio.id] = position;
                          });
                        }
                      });

                      // Reset when audio completes
                      _audioPlayer.onPlayerComplete.listen((_) {
                        if (mounted) {
                          setState(() => _isPlayingMap[audio.id] = false);
                        }
                      });
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Audio waveform visualization
              Container(
                width: 120,
                height: 24,
                margin: const EdgeInsets.only(bottom: 4),
                child: _buildWaveform(audio.id, isUserMessage),
              ),
              Text(
                audio.duration != null
                    ? _formatDuration(audio.duration!)
                    : '0:00',
                style: TextStyle(
                    fontSize: 11,
                    color: isUserMessage ? Colors.white70 : Colors.grey[600],
                    fontFamily: 'Nunito'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform(String audioId, bool isUserMessage) {
    final isPlaying = _isPlayingMap[audioId] ?? false;
    final position = _audioPositions[audioId] ?? Duration.zero;
    final duration =
        widget.message.medias.firstWhere((m) => m.id == audioId).duration ?? 0;

    final progress = duration > 0 ? position.inMilliseconds / duration : 0.0;

    final barCount = 20;
    List<double> barHeights = List.generate(
      barCount,
      (i) => 0.3 + 0.7 * ((i % 3 == 0) ? 0.8 : 0.5),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(barCount, (i) {
        final isActive = i / barCount <= progress;
        final height = barHeights[i];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isPlaying ? 4.0 + 14.0 * height : 10.0,
            width: 3,
            decoration: BoxDecoration(
              color: isUserMessage
                  ? (isActive ? Colors.white : Colors.white.withOpacity(0.4))
                  : (isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showFullScreenImage(BuildContext context, Media media) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () {
                    // Download functionality would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Image saved to gallery',
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    // Share functionality would go here
                  },
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Hero(
                  tag: media.id,
                  child: PhotoView(
                    imageProvider: CachedNetworkImageProvider(media.secureUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildExtractedTransactions(BuildContext context) {
    double totalAmount = 0.0;
    for (var transaction in widget.message.extractedTransactions) {
      double amount = transaction.type == 'Expense'
          ? -transaction.amount
          : transaction.amount;
      totalAmount += amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction Details',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: widget.message.role.toLowerCase() == "user"
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[800],
                  fontFamily: 'Nunito'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.message.extractedTransactions
            .map((transaction) => _buildTransactionCard(context, transaction))
            .toList(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (totalAmount >= 0 ? Colors.green : Colors.red)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (totalAmount >= 0 ? Colors.green : Colors.red)
                      .withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Total: ${totalAmount.toFormattedString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: totalAmount >= 0 ? Colors.green : Colors.red,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<double>(
          valueListenable: _confirmedAmountNotifier,
          builder: (context, confirmedAmount, _) {
            if (widget.message.extractedTransactions
                    .any((t) => t.confirmationStatus == 'Confirmed') ||
                confirmedAmount != 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            (confirmedAmount >= 0 ? Colors.green : Colors.red)
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              (confirmedAmount >= 0 ? Colors.green : Colors.red)
                                  .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Confirmed: ${confirmedAmount.toFormattedString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color:
                              confirmedAmount >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard(
      BuildContext context, ExtractedTransaction transaction) {
    final isExpense = transaction.type == 'Expense';
    final typeColor = isExpense ? Colors.red : Colors.green;
    final confirmedStatusNotifier =
        ValueNotifier<String>(transaction.confirmationStatus);
    final isUserMessage = widget.message.role.toLowerCase() == "user";

    return ValueListenableBuilder<String>(
      valueListenable: confirmedStatusNotifier,
      builder: (context, confirmedStatus, _) {
        final isPending = confirmedStatus == 'Pending';
        final statusColor = _getStatusColor(confirmedStatus);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: isUserMessage
                ? Colors.white.withOpacity(0.1)
                : Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1C1C1E)
                    : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: statusColor.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            transaction.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isUserMessage
                                    ? Colors.white
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                fontFamily: 'Nunito'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaction.type,
                            style: TextStyle(
                                color: typeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Nunito'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction.amount.toFormattedString(),
                          style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: 'Nunito'),
                        ),
                        if (transaction.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transaction.category!,
                              style: TextStyle(
                                  color: typeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            DateFormat('MMM d, yyyy')
                                .format(transaction.occurredAt),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Nunito'),
                          ),
                        ),
                        !isPending
                            ? _buildStatusChip(confirmedStatus)
                            : const SizedBox.shrink(),
                      ],
                    ),
                    if (isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            'Confirm',
                            Colors.white,
                            Colors.green,
                            () => _handleConfirmAction(
                              context,
                              transaction.id,
                              'Confirmed',
                              confirmedStatusNotifier,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            'Reject',
                            Colors.white,
                            Colors.red,
                            () => _handleConfirmAction(
                              context,
                              transaction.id,
                              'Rejected',
                              confirmedStatusNotifier,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleConfirmAction(
    BuildContext context,
    int transactionId,
    String status,
    ValueNotifier<String> statusNotifier,
  ) async {
    double amountChange = 0.0;
    try {
      statusNotifier.value = status;

      for (var transaction in widget.message.extractedTransactions) {
        if (transaction.id == transactionId) {
          double amount = transaction.type == 'Expense'
              ? -transaction.amount
              : transaction.amount;
          if (status == 'Confirmed') {
            amountChange = amount;
          } else if (status == 'Rejected' &&
              transaction.confirmationStatus == 'Confirmed') {
            amountChange = -amount;
          }
          break;
        }
      }

      _confirmedAmountNotifier.value += amountChange;

      if (widget.onConfirmTransaction != null) {
        await widget.onConfirmTransaction!(transactionId, status);

        AppSnackBar.showSuccess(
          context: context,
          message: status == 'Confirmed'
              ? 'Transaction confirmed'
              : 'Transaction rejected',
        );
      }
    } catch (e) {
      statusNotifier.value = 'Pending';
      _confirmedAmountNotifier.value -= amountChange;

      AppSnackBar.showError(
        context: context,
        message: 'Failed to process transaction. Please try again.',
        actionLabel: 'Retry',
        onActionPressed: () => _handleConfirmAction(
            context, transactionId, status, statusNotifier),
      );
    }
  }

  // Create action button with specified color
  Widget _buildActionButton(
    String label,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito'),
        ),
      ),
    );
  }

  // Display status chip
  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  // Determine color for each status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
