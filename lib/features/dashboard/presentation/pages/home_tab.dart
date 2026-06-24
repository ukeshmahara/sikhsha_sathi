import 'package:flutter/material.dart';

import '../widgets/category_card.dart';
import '../widgets/school_card.dart';

class HomeTab extends StatelessWidget {

  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // TOP BLUE SECTION
            Container(

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Colors.blue,

                borderRadius:
                BorderRadius.only(
                  bottomLeft:
                  Radius.circular(25),

                  bottomRight:
                  Radius.circular(25),
                ),
              ),

              child: const Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        'Hello, Ukesh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Find the best school for you',
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

            Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // SEARCH
                  Row(

                    children: [

                      Expanded(

                        child: TextField(

                          decoration: InputDecoration(

                            hintText:
                            'Search school, keyword',

                            prefixIcon:
                            const Icon(Icons.search),

                            filled: true,

                            fillColor:
                            Colors.grey.shade100,

                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                              borderSide:
                              BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(

                        padding:
                        const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(15),

                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        child: const Icon(
                          Icons.tune,
                        ),
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

                      SizedBox(width: 10),

                      Text(
                        'Kathmandu, Nepal',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // CATEGORY
                  Container(

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                        ),
                      ],
                    ),

                    child: const Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,

                      children: [

                        CategoryCard(
                          image:
                          'assets/images/international_school.png',

                          title:
                          'International Schools',

                          color:
                          Colors.blue,
                        ),

                        CategoryCard(
                          image:
                          'assets/images/public_school.png',

                          title:
                          'Public Schools',

                          color:
                          Colors.green,
                        ),

                        CategoryCard(
                          image:
                          'assets/images/budget_friendly.png',

                          title:
                          'Budget Friendly',

                          color:
                          Colors.purple,
                        ),

                        CategoryCard(
                          image:
                          'assets/images/top_rated.png',

                          title:
                          'Top Rated',

                          color:
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // RECOMMENDED
                  const Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        'Recommended for You',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(

                    height: 230,

                    child: ListView(

                      scrollDirection:
                      Axis.horizontal,

                      children: const [

                        SchoolCard(
                          image:
                          'assets/images/lincoln_school.jpg',

                          title:
                          'Lincoln School',

                          location:
                          'Pulchowk, Kathmandu',
                        ),

                        SchoolCard(
                          image:
                          'assets/images/british_school.jpg',

                          title:
                          'The British School',

                          location:
                          'Kathmandu',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // POPULAR
                  const Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        'Popular Schools',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(

                    height: 230,

                    child: ListView(

                      scrollDirection:
                      Axis.horizontal,

                      children: const [

                        SchoolCard(
                          image:
                          'assets/images/malpi_international.jpg',

                          title:
                          'Malpi International',

                          location:
                          'Bungamati, Lalitpur',
                        ),

                        SchoolCard(
                          image:
                          'assets/images/kathmandu_international_school.jpg',

                          title:
                          'Kathmandu International',

                          location:
                          'Kathmandu',
                        ),

                        SchoolCard(
                          image:
                          'assets/images/budhanilkantha.jpg',

                          title:
                          'Budhanilkantha School',

                          location:
                          'Kathmandu',
                        ),
                      ],
                    ),
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