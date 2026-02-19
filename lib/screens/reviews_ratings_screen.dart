import 'package:flutter/material.dart';

class ReviewsRatingsScreen extends StatefulWidget {
  const ReviewsRatingsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsRatingsScreen> createState() => _ReviewsRatingsScreenState();
}

class _ReviewsRatingsScreenState extends State<ReviewsRatingsScreen> {
  int _selectedFilter = 0; // 0=All, 1=My reviews, 2=Most recent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Reviews & Ratings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Overall rating card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B8FB9).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '4.6',
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    Icons.star,
                                    size: 18,
                                    color: i < 5
                                        ? const Color(0xFFF5A623)
                                        : Colors.grey[300],
                                  );
                                }),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Based on 12 reviews',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Rating bars
                      _buildRatingBar(5, 7, 12),
                      const SizedBox(height: 6),
                      _buildRatingBar(4, 3, 12),
                      const SizedBox(height: 6),
                      _buildRatingBar(3, 1, 12),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Filter
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip('All', 0),
                    const SizedBox(width: 10),
                    _buildFilterChip('My reviews', 1),
                    const SizedBox(width: 10),
                    _buildFilterChip('Most recent', 2),
                  ],
                ),
                const SizedBox(height: 28),

                // Recent reviews
                const Text(
                  'Recent reviews',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Review 1
                _buildReviewCard(
                  name: 'Downtown Hub',
                  time: '2 days ago',
                  stars: 5,
                  review: 'Quiet and clean. Wi-Fi was fast and stable.',
                  tags: ['Quiet', 'Fast Wi-Fi'],
                ),
                const SizedBox(height: 14),

                // Review 2
                _buildReviewCard(
                  name: 'City Study Room',
                  time: '1 week ago',
                  stars: 4,
                  review:
                      'Great for studying. Seats were limited at peak hours.',
                  tags: ['Best for study', 'Good value'],
                ),
                const SizedBox(height: 14),

                // Tip
                Text(
                  'Tip: You can edit your reviews from Space',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    final fraction = count / total;
    // Gradient colors: 5 stars = orange→blue, 4 stars = orange→green, 3 stars = blue
    Color barColor;
    List<Color>? gradientColors;
    if (stars == 5) {
      gradientColors = [const Color(0xFFF5A623), const Color(0xFF5B8FB9)];
    } else if (stars == 4) {
      gradientColors = [const Color(0xFFF5A623), const Color(0xFF7CB342)];
    } else {
      gradientColors = [const Color(0xFF5B8FB9), const Color(0xFF5B8FB9)];
    }

    return Row(
      children: [
        SizedBox(
          width: 14,
          child: Text(
            '$stars',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 14,
          child: Text(
            '$count',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : const Color(0xFF5B8FB9).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFF5A623) : Colors.black87,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.black : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String time,
    required int stars,
    required String review,
    required List<String> tags,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF5B8FB9).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Stars
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < stars ? Icons.star : Icons.star_border,
                size: 16,
                color: const Color(0xFFF5A623),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Review text
          Text(review, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 12),
          // Tags
          Row(
            children: tags.map((tag) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
