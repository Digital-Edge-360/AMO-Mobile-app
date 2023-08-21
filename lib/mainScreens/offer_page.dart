import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Padding(
        padding: EdgeInsets.only(right: 30),
        child: Text("Offer",style: TextStyle(fontFamily:"Poppins"),),
      ))),
      body: SizedBox(
        height: 200,
        width: 600,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('coupon').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount:snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Card(
                      child: Container(
                        width:600,
                        child: Column(
                          children: [
                            Text("Coupon Code: ${snapshot.data!.docs[index]['code'].toString()}",style: TextStyle(fontFamily:"Poppins",color: Colors.green),),
                            Text("${snapshot.data!.docs[index]['off'].toString()}%",style: TextStyle(fontFamily:"Poppins",color: Colors.amber),)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),

    );
  }
}
