import 'package:flutter/material.dart';

import '../models/study_material.dart';

class AttachmentUploadStatus extends StatelessWidget {
  const AttachmentUploadStatus({
    super.key,
    required this.attachments,
    this.showProgress = false,
  });

  final List<GeminiLocalAttachment> attachments;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> tiles = attachments
        .map((GeminiLocalAttachment attachment) => _AttachmentTile(
              attachment: attachment,
              showProgress: showProgress,
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: tiles
          .expand<Widget>((Widget tile) => <Widget>[tile, const SizedBox(height: 12)])
          .toList()
          ..removeLast(),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.attachment,
    required this.showProgress,
  });

  final GeminiLocalAttachment attachment;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final TextStyle nameStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4D4D4D),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ) ??
        const TextStyle(
          color: Color(0xFF4D4D4D),
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );

    final TextStyle sizeStyle = nameStyle.copyWith(
      color: const Color(0xFF787878),
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11000000)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.insert_drive_file,
                size: 20,
                color: Color(0xFF787878),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(attachment.displayName, style: nameStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(_formatSize(attachment.sizeBytes), style: sizeStyle),
                  ],
                ),
              ),
            ],
          ),
          if (showProgress) ...<Widget>[
            const SizedBox(height: 12),
            const LinearProgressIndicator(minHeight: 6),
          ],
        ],
      ),
    );
  }

  static String _formatSize(int bytes) {
    if (bytes <= 0) {
      return 'Unknown size';
    }

    const int kb = 1024;
    const int mb = kb * 1024;

    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }

    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }

    return '$bytes B';
  }
}
