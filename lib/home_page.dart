import 'package:flutter/material.dart';
import 'gift_selections_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom header with a curved shape and gradient
          ClipPath(
            clipper: CustomHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.home, size: 80, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Welcome section
                const Text(
                  'Welcome to the Gift Finder App!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Looking for the perfect gift? We\'ve got you covered! Browse through our collection of handpicked gifts for every occasion.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Featured Gifts Section
                const Text(
                  'Featured Gifts',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GiftCard(
                        title: 'Gift 1',
                        image: const AssetImage('images/G2050-BLUE.jpg'),
                      ),
                      GiftCard(
                        title: 'Gift 2',
                        image: const AssetImage('images/bag.jpg'),
                      ),
                      GiftCard(
                        title: 'Gift 3',
                        image: const AssetImage('images/kit.jpg'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Categories Section with Fashion, Beauty, Gaming, Sports
                const Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryCard(
                      categoryName: 'Fashion',
                      icon: Icons.style,
                    ),
                    CategoryCard(
                      categoryName: 'Beauty',
                      icon: Icons.brush,
                    ),
                    CategoryCard(
                      categoryName: 'Gaming',
                      icon: Icons.videogame_asset,
                    ),
                    CategoryCard(
                      categoryName: 'Sports',
                      icon: Icons.sports,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Footer section with call to action
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.deepPurple,
                  child: Column(
                    children: [
                      const Text(
                        'Still unsure? Browse through all the gifts and find the perfect one!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GiftSelectionPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Start Exploring Gifts',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gifts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Custom clipper to create a curved header
class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);
    final firstControlPoint = Offset(size.width / 2, size.height);
    final firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Gift Card widget for featured gifts
class GiftCard extends StatelessWidget {
  final String title;
  final dynamic image; // Can be an AssetImage or a String (URL)

  const GiftCard({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          image is String && image.contains('http')
              ? Image.network(image, height: 120, width: 120, fit: BoxFit.cover)
              : Image(image: image, height: 120, width: 120, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Card widget for different categories
class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData icon;

  const CategoryCard({required this.categoryName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.deepPurple),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
