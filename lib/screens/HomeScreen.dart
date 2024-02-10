import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/screens/DetailsScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:pet_adoption_app/screens/silver_adopted_app_bar.dart';
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
  List<Pet> adoptedPets = [];

  List<Pet> displayedPets = []; // List to store filtered pets

  @override
  void initState() {
    super.initState();
    displayedPets.addAll(availablePets); // Initialize displayedPets with availablePets
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildPersistentHeader(),
          _currentIndex == 0
              ? _buildAvailablePetsSliver()
              : _currentIndex == 1
                  ? _buildHomeSliver() // Display the home screen when the middle tab is selected
                  : _buildAdoptedPetsSliver(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color.fromARGB(255, 45, 199, 255),
        activeColor: Color.fromARGB(255, 255, 255, 255),
        style: TabStyle.fixedCircle,
        curve: Curves.bounceInOut,
        items: [
          TabItem(icon: Icons.pets_outlined, title: 'Available Pets'),
          TabItem(
            icon: Image.asset('assets/petss.png'),
            title: '',
          ),
          TabItem(icon: Icons.favorite, title: 'Adopted Pets'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          if (index == 1) {
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPersistentHeader() {
    return SliverPersistentHeader(
      delegate: _currentIndex == 0
          ? SliverSearchAppBar(
              onSearch: (query) {
                setState(() {
                  if (query.isEmpty) {
                    displayedPets =
                        List.from(availablePets); // Show all available pets if query is empty
                  } else {
                    displayedPets = availablePets
                        .where((pet) => pet.name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList(); // Filter pets based on search query
                  }
                });
              },
            )
          : SliverAdoptedPetsAppBar(),
      pinned: true,
    );
  }

  Widget _buildAvailablePetsSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildAvailablePetItem(context, displayedPets[index]);
        },
        childCount: displayedPets.length,
      ),
    );
  }

  Widget _buildAdoptedPetsSliver() {
    List<Pet> reversedAdoptedPets = List.from(adoptedPets.reversed);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildAdoptedPetItem(context, reversedAdoptedPets[index]);
        },
        childCount: reversedAdoptedPets.length,
      ),
    );
  }

  Widget _buildHomeSliver() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/petss.png', width: 200, height: 200), // Replace 'your_image.png' with your image asset
          SizedBox(height: 20),
          Text(
            'Adopt Pet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Build Life',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'in Homes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptedPetItem(BuildContext context, Pet pet) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        color: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage('assets/bck2.jpg'),
              fit: BoxFit.cover,
            ),
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
                    _buildLabel('Name:', pet.name),
                    SizedBox(height: 8),
                    _buildLabel('Age:', pet.age.toString()),
                    SizedBox(height: 8),
                    _buildLabel('Price:', '\$${pet.price}'),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 182, 246),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePetItem(BuildContext context, Pet pet) {
    final bool isAdopted = adoptedPets.contains(pet);
    final bool isAvailable = availablePets.contains(pet);

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
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
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          child: Stack(
            children: [
              Container(
                foregroundDecoration: isAdopted
                    ? BoxDecoration(
                        color: Colors.grey.withOpacity(1),
                        backgroundBlendMode: BlendMode.saturation,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(22),
                      )
                    : null,
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('assets/bck2.jpg'),
                        fit: BoxFit.cover,
                      ),
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
                              _buildLabelAvailable('Name:', pet.name),
                              SizedBox(height: 8),
                              _buildLabelAvailable('Age:', pet.age.toString()),
                              SizedBox(height: 8),
                              _buildLabelAvailable('Price:', '\$${pet.price}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isAdopted)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Adopted",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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

  Widget _buildLabelAvailable(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 182, 246),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }

  void adoptPet(Pet pet) {
    setState(() {
      adoptedPets.insert(0, pet); // Add the newly adopted pet to the beginning of the list
      availablePets.remove(pet);
    });
  }
}
