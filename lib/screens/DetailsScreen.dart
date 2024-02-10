import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/screens/background_wave.dart';

class DetailsPage extends StatelessWidget {
  final Pet pet;
  final List<Pet> availablePets;
  final List<Pet> adoptedPets;
  final Function(Pet) updateLists; // Modify this line

  const DetailsPage({
    Key? key,
    required this.pet,
    required this.availablePets,
    required this.adoptedPets,
    required this.updateLists, // Modify this line
  }) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Adoption',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 53, 193, 244),
                Color.fromARGB(255, 246, 246, 218),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          BackgroundWave(height: MediaQuery.of(context).size.height),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                margin: EdgeInsets.all(30),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage('assets/bck1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Hero(
                          tag: 'petImage${pet.name}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(pet.imageUrl),
                              radius: 100,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildLabel('Name: ${pet.name}',''),
                        _buildLabel('Age: ${ pet.age.toString()}',''),
                        _buildLabel('Price:${pet.price.toString()}', ''),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                         updateLists(pet);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Adopt Me'),
                                  content: Text('You\'ve now adopted ${pet.name}!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow, // Set button color here
                          ),
                          child: Text('Adopt Me'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all( 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue, // You can change the color here
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
