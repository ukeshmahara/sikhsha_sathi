import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Widget categoryItem(String image, String title) {

    return Column(
      children: [

        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.transparent,

          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget schoolCard(
    String image,
    String schoolName,
    String location,
  ) {

    return Container(
      width: 170,

      margin: const EdgeInsets.only(right: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),

            child: Image.asset(
              image,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  schoolName,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  location,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // TOP BLUE CONTAINER
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF4D8DFF),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Hello, Ukesh",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Find the best school for you",

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SEARCH BAR
            Row(
              children: [

                Expanded(
                  child: TextField(

                    decoration: InputDecoration(

                      hintText: "Search school, keyword",

                      prefixIcon: const Icon(Icons.search),

                      filled: true,

                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(Icons.tune),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LOCATION
            const Row(
              children: [

                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),

                SizedBox(width: 6),

                Text(
                  "Kathmandu, Nepal",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // CATEGORY SECTION
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  categoryItem(
                    'assets/images/international_school.png',
                    'International\nSchools',
                  ),

                  categoryItem(
                    'assets/images/public_school.png',
                    'Public\nSchools',
                  ),

                  categoryItem(
                    'assets/images/budget_friendly.png',
                    'Budget\nFriendly',
                  ),

                  categoryItem(
                    'assets/images/top_rated.png',
                    'Top\nRated',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // RECOMMENDED TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Recommended for You",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {},

                  child: const Text("See All"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // RECOMMENDED SCHOOLS
            SizedBox(
              height: 220,

              child: ListView(
                scrollDirection: Axis.horizontal,

                children: [

                  schoolCard(
                    'assets/images/lincoln_school.png',
                    'Lincoln School',
                    'Pulchowk, Kathmandu',
                  ),

                  schoolCard(
                    'assets/images/british_school.jpg',
                    'The British School',
                    'Kathmandu',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // POPULAR TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Popular Schools",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {},

                  child: const Text("See All"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // POPULAR SCHOOLS
            SizedBox(
              height: 220,

              child: ListView(
                scrollDirection: Axis.horizontal,

                children: [

                  schoolCard(
                    'assets/images/malpi_international.png',
                    'Malpi International',
                    'Bungamati, Lalitpur',
                  ),

                  schoolCard(
                    'assets/images/kathmandu_internation_school.jpg',
                    'Kathmandu International',
                    'Kathmandu',
                  ),

                  schoolCard(
                    'assets/images/budhanilkantha.jpg',
                    'Budhanilkantha School',
                    'Kathmandu',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}