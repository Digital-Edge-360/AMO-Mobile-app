import 'package:flutter/material.dart';

import '../assistants/request_assistant.dart';
import '../global/map_key.dart';
import '../models/predicted_places.dart';
import '../widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  List<PredictedPlaces> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async  {
    if(inputText.length > 1){
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";
      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
      if(responseAutoCompleteSearch == 'Error Occured.'){
        return;
      }

      if(responseAutoCompleteSearch["status"] == "OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();
        setState(() {
          placePredictedList = placePredictionsList;
        });
      }

      print("this is the response from places API:");
      print(responseAutoCompleteSearch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          //search place ui
          Container(
            height: 180,
            decoration: const BoxDecoration(color: Colors.black54, boxShadow: [
              BoxShadow(
                color: Colors.white54,
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: Offset(
                  0.7,
                  0.7,
                ),
              ),
            ]),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.grey,
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Search and select drop off location',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.adjust_sharp,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 18,),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              onChanged: (valueTyped){
                                findPlaceAutoCompleteSearch(valueTyped);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search here..',
                                fillColor: Colors.white54,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          //display place prediction results
          (placePredictedList.length > 0)
              ? Expanded(child: ListView.separated(
            physics: ClampingScrollPhysics(),
            itemCount: placePredictedList.length,
            itemBuilder: (context, index){
              return PlacePredictionTileDesign(
                predictedPlaces: placePredictedList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index){
              return const Divider(
                height: 1,
                color: Colors.white,
                thickness: 1,
              );
            },
          ),):
          Container(),
        ],
      ),
    );
  }
}
