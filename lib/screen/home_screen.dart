import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../provider/loction_provider.dart';
import '../screen/help_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationNameController = TextEditingController();

  bool textKey = false;

  @override
  void initState() {
    Provider.of<LocationProvider>(context, listen: false).getLocationName();
    _locationNameController.text =
        Provider.of<LocationProvider>(context, listen: false).prefData;
    super.initState();
  }

  @override
  void dispose() {
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ActionChip(
              label: const Text("Help"),
              onPressed: () {
                // to go to help screen
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HelpScreen()));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.streetAddress,
              controller: _locationNameController,
              decoration: InputDecoration(
                hintText: "Enter location name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  textKey = _locationNameController.value.text.isNotEmpty;
                });
                // call getWeather by location
                Provider.of<LocationProvider>(context, listen: false)
                    .getWeatherByLocation(_locationNameController.text);

                Provider.of<LocationProvider>(context, listen: false)
                    .setLoctionName(_locationNameController.text);
              },
              child: textKey ? const Text("Update") : const Text("Save"),
            ),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(111, 98, 184, 218),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<LocationProvider>(
                builder: (context, value, child) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          value.locationData?.tempC.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          value.locationData?.conditionText ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        if (value.locationData?.iconUrl != null)
                          CachedNetworkImage(
                            imageUrl: 'http:${value.locationData?.iconUrl}',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
