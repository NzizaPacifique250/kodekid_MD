import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({super.key, required this.videoUrl});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final WebViewController _webController;
  bool _loadFailed = false;
  bool _pageChecked = false;

  String _extractVideoId(String url) {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return '';
      // common YouTube patterns
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      }
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'] ?? '';
      }
      final reg = RegExp(r'(?:(?:embed/)|(?:v/))([A-Za-z0-9_-]{11})');
      final m = reg.firstMatch(url);
      return m != null ? m.group(1)! : '';
    } catch (_) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    final id = _extractVideoId(widget.videoUrl);
    _webController = WebViewController();
    _webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) async {
          // After page load, perform a quick text check to detect
          // whether the embed failed and shows a "Watch on YouTube" message.
          if (!_pageChecked) {
            try {
              final content = await _webController
                  .runJavaScriptReturningResult('document.body.innerText');
              final text = content.toString().toLowerCase();
              if (text.contains('watch on youtube') ||
                  text.contains('play on youtube') ||
                  text.contains('this video is unavailable') ||
                  text.contains(
                      'playback on other websites has been disabled')) {
                setState(() => _loadFailed = true);
              }
            } catch (_) {
              // ignore js errors
            }
            _pageChecked = true;
          }
        },
        onWebResourceError: (err) {
          setState(() => _loadFailed = true);
        },
      ))
      ..loadRequest(
        Uri.parse('https://www.youtube.com/embed/$id?autoplay=1&controls=1'),
      );
  }

  @override
  Widget build(BuildContext context) {
    final id = _extractVideoId(widget.videoUrl);
    if (id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Video')),
        body: const Center(child: Text('Invalid YouTube URL')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
        actions: [
          IconButton(
            tooltip: 'Open in YouTube',
            icon: const Icon(Icons.open_in_new),
            onPressed: () async {
              final uri = Uri.parse('https://www.youtube.com/watch?v=$id');
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open YouTube')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.width) * 9 / 16,
          child: _loadFailed
              ? _buildEmbedFailed(context, id)
              : WebViewWidget(controller: _webController),
        ),
      ),
    );
  }

  Widget _buildEmbedFailed(BuildContext context, String id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
        const SizedBox(height: 12),
        const Text('Embedding unavailable for this video.'),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: const Text('Open in YouTube'),
          onPressed: () async {
            final uri = Uri.parse('https://www.youtube.com/watch?v=$id');
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open YouTube')),
              );
            }
          },
        ),
      ],
    );
  }
}
