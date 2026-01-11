import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Theme/appColors.dart';
import 'projectDetailsScreen.dart';

class ExploreScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final DatabaseReference dbRef;
  const ExploreScreen({super.key,required this.auth, required this.dbRef});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedFilter = 0;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> projects = [
    {
      'title': 'Solar Farm Alpha',
      'category': 'Energy',
      'roi': '15%',
      'progress': 0.85,
      'goal': '\$500,000',
      'raised': '\$425,000',
      'daysLeft': 45,
      'image': 'assets/images/solar farm alpha.jpg',
      'isTrending': true,
      'returnType': 'High',
    },
    {
      'title': 'Eco-Hotel Bali',
      'category': 'Real Estate',
      'roi': '10%',
      'progress': 0.30,
      'goal': '\$1,200,000',
      'raised': '\$360,000',
      'daysLeft': 120,
      'image': 'assets/images/eco hotel bali.webp',
      'isTrending': false,
      'returnType': 'Medium',
    },
    {
      'title': 'Cyber Security AI',
      'category': 'Tech',
      'roi': '22%',
      'progress': 0.55,
      'goal': '\$300,000',
      'raised': '\$165,000',
      'daysLeft': 30,
      'image': 'assets/images/cybersecurity.jpg',
      'isTrending': true,
      'returnType': 'High',
    },
    {
      'title': 'Vertical Farm NY',
      'category': 'Agriculture',
      'roi': '12%',
      'progress': 0.15,
      'goal': '\$800,000',
      'raised': '\$120,000',
      'daysLeft': 90,
      'image': 'assets/images/farming.jpg',
      'isTrending': false,
      'returnType': 'Medium',
    },
    {
      'title': 'EV Charging Network',
      'category': 'Green Tech',
      'roi': '18%',
      'progress': 0.70,
      'goal': '\$750,000',
      'raised': '\$525,000',
      'daysLeft': 15,
      'image': 'assets/images/ev charge.jpg',
      'isTrending': true,
      'returnType': 'High',
    },
    {
      'title': 'Medical AI Diagnosis',
      'category': 'Medical',
      'roi': '25%',
      'progress': 0.40,
      'goal': '\$2,000,000',
      'raised': '\$800,000',
      'daysLeft': 60,
      'image': 'assets/images/midical ai diagnosis.jpg',
      'isTrending': true,
      'returnType': 'High',
    },
  ];

  List<String> filters = ["All", "Trending", "Newest", "High Return"];
  List<String> categories = ["All", "Energy", "Real Estate", "Tech", "Agriculture", "Medical", "Green Tech"];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProjects = _filterProjects();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Explore Projects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textMain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search projects, categories...",
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),

          //filter chips row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sort by:",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10, left: index == 0 ? 0 : 0),
                        child: ChoiceChip(
                          label: Text(filters[index],
                              style: TextStyle(
                                  color: _selectedFilter == index
                                      ? Colors.white
                                      : AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                          selected: _selectedFilter == index,
                          selectedColor: AppColors.accent,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedFilter == index
                                  ? AppColors.accent
                                  : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? index : 0;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          //category chips row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories:",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10, left: index == 0 ? 0 : 0),
                        child: FilterChip(
                          label: Text(categories[index],
                              style: TextStyle(
                                  color: _selectedCategory == categories[index]
                                      ? Colors.white
                                      : AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)
                          ),
                          selected: _selectedCategory == categories[index],
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedCategory == categories[index]
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? categories[index] : 'All';
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          //project grid/list
          Expanded(
            child: filteredProjects.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 60, color: AppColors.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    "No projects found",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try different search or filter",
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                return _buildExploreCard(context, filteredProjects[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterProjects() {
    List<Map<String, dynamic>> result = List.from(projects);

    //filter by search
    if (_searchController.text.isNotEmpty) {
      result = result.where((project) {
        return project['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
            project['category'].toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    //filter by category
    if (_selectedCategory != 'All') {
      result = result.where((project) => project['category'] == _selectedCategory).toList();
    }

    //filter by sort type
    switch (_selectedFilter) {
      case 1: //trending
        result = result.where((project) => project['isTrending'] == true).toList();
        break;
      case 2: //newest (simulated with daysLeft)
        result.sort((a, b) => a['daysLeft'].compareTo(b['daysLeft']));
        break;
      case 3: //high return
        result = result.where((project) => project['returnType'] == 'High').toList();
        break;
    }

    return result;
  }

  Widget _buildExploreCard(BuildContext context, Map<String, dynamic> project, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsScreen(
              title: project['title'],
              category: project['category'],
              progress: project['progress'],
              image: project['image'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            //project image with category tag
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image:
                    DecorationImage(
                      image: AssetImage(project['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project['category'],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                if (project['isTrending'])
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Trending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getROIColor(project['roi']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          project['roi'],
                          style: TextStyle(
                            color: _getROIColor(project['roi']),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  //progress bar with labels
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Raised: ${project['raised']}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                            ),
                          ),
                          Text(
                            "Goal: ${project['goal']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: project['progress'],
                          color: AppColors.primary,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(project['progress'] * 100).toInt()}% funded",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                            ),
                          ),
                          Text(
                            "${project['daysLeft']} days left",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            //save to bookmarks
                          },
                          icon: const Icon(Icons.bookmark_border, size: 16),
                          label: const Text("Save", style: TextStyle(fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            //invest now
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailsScreen(
                                  title: project['title'],
                                  category: project['category'],
                                  progress: project['progress'],
                                  // image: project['image'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            "Invest Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getROIColor(String roi) {
    double value = double.tryParse(roi.replaceAll('%', '')) ?? 0;
    if (value >= 20) return Colors.green;
    if (value >= 15) return Colors.green.shade600;
    if (value >= 10) return Colors.orange;
    return Colors.red;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Advanced Filters",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 20),
              //add more filter options here
              const Text("Coming soon...", style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}