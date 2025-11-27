class GeminiFileAttachment {
	const GeminiFileAttachment({
		required this.resourceName,
		required this.displayName,
		required this.mimeType,
		required this.sizeBytes,
		required this.state,
		required this.uri,
		this.downloadUri,
	});

	final String resourceName;
	final String displayName;
	final String mimeType;
	final int sizeBytes;
	final String state;
	final String uri;
	final String? downloadUri;

	bool get isActive => state.toUpperCase() == 'ACTIVE';
	Uri? get uriReference => uri.isEmpty ? null : Uri.tryParse(uri);

	Map<String, dynamic> toJson() {
		return <String, dynamic>{
			'name': resourceName,
			'displayName': displayName,
			'mimeType': mimeType,
			'sizeBytes': sizeBytes,
			'state': state,
			'uri': uri,
			'downloadUri': downloadUri,
		};
	}

	factory GeminiFileAttachment.fromJson(Map<String, dynamic> json) {
		final int parsedSize = _parseSize(json['sizeBytes']);
		final String rawDownloadUri = (json['downloadUri'] as String? ?? '').trim();
		return GeminiFileAttachment(
			resourceName: (json['name'] as String? ?? '').trim(),
			displayName: (json['displayName'] as String? ?? '').trim(),
			mimeType: (json['mimeType'] as String? ?? 'application/octet-stream').trim(),
			sizeBytes: parsedSize,
			state: (json['state'] as String? ?? '').trim(),
			uri: (json['uri'] as String? ?? '').trim(),
			downloadUri: rawDownloadUri.isEmpty ? null : rawDownloadUri,
		);
	}

	static int _parseSize(Object? value) {
		if (value is int) {
			return value;
		}
		if (value is String) {
			return int.tryParse(value) ?? 0;
		}
		return 0;
	}
}
