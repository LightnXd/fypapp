import 'package:flutter/material.dart';

class DynamicImageColumn extends StatelessWidget {
  final List<String?> imageUrls;
  final double totalImageHeight;

  const DynamicImageColumn({
    Key? key,
    required this.imageUrls,
    this.totalImageHeight = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int count = imageUrls.length;
    final int displayCount = count >= 4 ? 4 : count;
    final bool isTwo = displayCount == 2;
    final int rows = isTwo ? 1 : (displayCount / 2).ceil();
    final double rowHeight = totalImageHeight / (rows == 0 ? 1 : rows);

    Widget buildItem(int index) {
      final url = imageUrls[index];
      final bool isLastSlot = index == 3 && count > 4;
      final extraCount = count - 4;

      return GestureDetector(
        onTap: () => _openGallery(context, index),
        child: SizedBox(
          height: rowHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url != null)
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallback(),
                )
              else
                _buildFallback(),

              if (isLastSlot)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+$extraCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (displayCount <= 1) return Column(children: [buildItem(0)]);

    if (isTwo) {
      return SizedBox(
        height: rowHeight,
        child: Row(
          children: List.generate(2, (i) => Expanded(child: buildItem(i))),
        ),
      );
    }

    return Column(
      children: List.generate(rows, (rowIndex) {
        final start = rowIndex * 2;
        final countInRow = (displayCount >= start + 2)
            ? 2
            : (displayCount - start);
        return SizedBox(
          height: rowHeight,
          child: Row(
            children: List.generate(countInRow, (colIndex) {
              return Expanded(child: buildItem(start + colIndex));
            }),
          ),
        );
      }),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
      ),
    );
  }

  void _openGallery(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GalleryViewer(
          imageUrls: imageUrls.where((e) => e != null).cast<String>().toList(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class GalleryViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const GalleryViewer({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _GalleryViewerState createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final PageController _controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < widget.imageUrls.length - 1;

    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color.fromRGBO(8, 8, 8, 0.7)),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          if (hasPrev)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
          if (hasNext)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
