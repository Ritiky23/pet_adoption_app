import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/screens/DetailsScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:pet_adoption_app/screens/silver_search_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Pet> availablePets = [
    Pet(name: 'Fluffy', age: 2, price: 50, imageUrl: 'assets/dog2.jpg'),
    Pet(name: 'Buddy', age: 3, price: 100, imageUrl: 'assets/cat1.jpg'),
    Pet(name: 'Tommy', age: 2, price: 50, imageUrl: 'assets/dog1.jpg'),
    Pet(name: 'Sheru', age: 3, price: 100, imageUrl: 'assets/dog3.jpg'),
    Pet(name: 'Tuffy', age: 2, price: 50, imageUrl: 'assets/cat1.jpg'),
    Pet(name: 'Barbie', age: 3, price: 100, imageUrl: 'assets/cat2.jpg'),
    Pet(name: 'Teddy', age: 2, price: 50, imageUrl: 'assets/cat1.jpg'),
    Pet(name: 'Picku', age: 3, price: 100, imageUrl: 'assets/rabbit1.jpg'),
    Pet(name: 'rusty', age: 2, price: 50, imageUrl: 'assets/cat1.jpg'),
    Pet(name: 'Berry', age: 3, price: 100, imageUrl: 'assets/rabbit2.jpg'),
    // Add more pets as needed
  ];
  List<Pet> adoptedPets = [
    Pet(name: 'Snowball', age: 2, price: 50, imageUrl: 'assets/cat3.jpg'),
    Pet(name: 'Max', age: 3, price: 100, imageUrl: 'assets/dog4.jpg'),
    // Add more adopted pets as needed
  ];

  List<Pet> displayedPets = []; // List to store filtered pets

  @override
  void initState() {
    super.initState();
    displayedPets.addAll(availablePets); // Initialize displayedPets with availablePets
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Adopt',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverSearchAppBar(
              onSearch: (query) {
                setState(() {
                  if (query.isEmpty) {
                    displayedPets = List.from(availablePets); // Show all available pets if query is empty
                  } else {
                    displayedPets = availablePets
                        .where((pet) =>
                            pet.name.toLowerCase().contains(query.toLowerCase()))
                        .toList(); // Filter pets based on search query
                  }
                });
              },
            ),
            pinned: true,
          ),
          _currentIndex == 0
              ? _buildAvailablePetsSliver()
              : _buildAdoptedPetsSliver(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color.fromARGB(255, 255, 213, 1),
        activeColor: Colors.white,
        style: TabStyle.fixedCircle,
        curve: Curves.bounceInOut,
        items: [
          TabItem(icon: Icons.pets, title: 'Available Pets'),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.favorite, title: 'Adopted Pets'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          if (index != 1) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildAvailablePetsSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildPetItem(context, displayedPets[index]);
        },
        childCount: displayedPets.length,
      ),
    );
  }

  Widget _buildAdoptedPetsSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildPetItem(context, adoptedPets[index]);
        },
        childCount: adoptedPets.length,
      ),
    );
  }

  Widget _buildPetItem(BuildContext context, Pet pet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              pet: pet,
              availablePets: availablePets,
              adoptedPets: adoptedPets,
              updateLists: (Pet adoptedPet) {
                setState(() {
                  adoptedPets.add(adoptedPet);
                  availablePets.remove(adoptedPet);
                });
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          color: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'petImage${pet.name}',
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Age: ${pet.age}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${pet.price}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void adoptPet(Pet pet) {
    setState(() {
      adoptedPets.add(pet);
      availablePets.remove(pet);
    });
  }
}
