import 'package:amo_cabs/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assistants/request_assistant.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../models/predicted_places.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  const PlacePredictionTileDesign({super.key, this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting up drop-off, please wait",
        ),
    );
    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == 'Error Occured.'){
      return;
    }



    if(responseApi["status"] == "OK"){
      Directions directions = Directions();
      directions.locationId = placeId;
      directions.locationName = responseApi['result']['name'];
      directions.locationLatitude = responseApi['result']['geometry']['location']['lat'];
      directions.locationLongitude = responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      
      Navigator.pop(context, "obtainedDropOff");

      // print("loaction name = " + directions.locationName!.toString());

    }

  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white
      ),
      onPressed: () {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),

                  ),

                  const SizedBox(height: 2,),

                  Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),

                  ),

                  const SizedBox(height: 8,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
