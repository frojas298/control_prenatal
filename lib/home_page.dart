import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenatal Care App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Cuenta'),
              onTap: () {
                Navigator.pushNamed(context, '/registration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pregnant_woman),
              title: const Text('Control prenatal'),
              onTap: () {
                Navigator.pushNamed(context, '/prenatal');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: [
            'assets/image1.jpg',
            'assets/image2.jpg',
            'assets/image3.jpg',
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Image.asset(i, fit: BoxFit.cover);
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pregnant_woman),
            label: 'Cuidado prenatal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Hospitales',
          ),
        ],
        currentIndex: 0, // Asume que estás en la primera pestaña
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/prenatal');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/hospitals');
          }
        },
      ),
    );
  }
}
