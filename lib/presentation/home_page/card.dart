part of 'home_page.dart';

typedef OnLikeCallback = void Function(String? id, String title, bool isLiked)?;

class _Card extends StatelessWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;
  final OnLikeCallback onLike;
  final VoidCallback? onTap;
  final String? id;
  final bool isLiked;

  const _Card(
      this.text, {
        this.icon = Icons.ac_unit_outlined,
        required this.descriptionText,
        this.imageUrl,
        this.onLike,
        this.onTap,
        this.id,
        this.isLiked = false,
      });

  factory _Card.fromData(
      CardData data, {
        OnLikeCallback onLike,
        VoidCallback? onTap,
        bool isLiked = false,
      }) => _Card(
    data.text,
    descriptionText: data.descriptionText,
    icon: data.icon,
    imageUrl: data.imageUrl,
    onLike: onLike,
    onTap: onTap,
    id: data.imdbId,
    isLiked: isLiked,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Убрали widget.
      child: Container(
        margin: const EdgeInsets.all(15),
        constraints: const BoxConstraints(minHeight: 180),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: SizedBox(
                  height: double.infinity,
                  width: 120,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          imageUrl ?? '', // Убрали widget.
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network('https://avatars.mds.yandex.net/i?id=ada6603a1f5596fff2c2232d9f7f63cf_l-4011133-images-thumbs&n=13'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text, // Убрали widget.
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        descriptionText, // Убрали widget.
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 16,
                    bottom: 16,
                  ),
                  child: GestureDetector(
                    onTap: () => onLike?.call(id, text, isLiked), // Убрали setState
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLiked
                          ? const Icon(
                        Icons.favorite,
                        color: Colors.amber,
                        key: ValueKey<int>(0),
                      )
                          : const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        key: ValueKey<int>(1),
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
}