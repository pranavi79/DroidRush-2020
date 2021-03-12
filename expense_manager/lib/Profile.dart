import 'package:expense_manager/fireauth.dart';
import 'package:expense_manager/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/charts/Lent/lent_class.dart';
import 'package:expense_manager/charts/Lent/lent_chart.dart';
import 'package:expense_manager/charts/Owe/owe_class.dart';
import 'package:expense_manager/charts/Owe/owe_chart.dart';
import 'edit_profile.dart';
import 'firestorageservice.dart';

String userAvatarUrl='https://www.veterinarypracticenews.com/wp-content/uploads/2019/08/bigstock-Little-Striped-Cute-Kitten-Sit-244080397.jpg';

/*
* Profile picture can be uploaded in the edit profile page
* It is stored in firebase storage in image/img.uid
* Failed trying to display the picture on screen
* Something about async functions I think, Its only displaying the default picture and not waiting for the
* async method to check to see if there is a profile picture in firebase storage
* We know it does check to see because I print out the image and it gives me a link to the image
* The state doesnt set with displaying the picture stored in firebase
*
* */

class Profile extends StatefulWidget {
  final User curr;

  Profile({this.curr});

  @override
  _ProfileState createState() => _ProfileState();

}


class _ProfileState extends State<Profile> {
  final _fire=fireauth();
  final List<lentobject> lentlist= List<lentobject>();
  final List<Oweobject> owelist= List<Oweobject>();
  FirebaseAuth auth = FirebaseAuth.instance;
  User curr;
  String uid;
  String username;
  Image profileImage;
  Image profileImage1;
  //bool finish=false;


  @override
  void initState(){
    imageFromStorage(context, 'image/img.$uid')?.then((img){
      setState(() {
        profileImage=img;                                             /*This isnt working. idk.*/
      });
    });
    if(profileImage==null){
      print('Its null in init');
      profileImage=Image.asset('images/defaultProfile.png');
    }
    super.initState();
  }

  Future imageFromStorage(BuildContext context, String filePath) async{
    Image m;
    String image=filePath;
    await FireStorageService?.loadFromStorage(context, image)?.then((downloadUrl) { //A function we defined that
      m = Image.network(                                                    //returns the URL of the picture
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return m;                         //returns an Image
  }

  Future displayPicture() async {
    profileImage1 = await this?.imageFromStorage(
        context, 'image/img.$uid'); // Calls the function to go to storage
                                    //And acquire the picture
    if(profileImage1==null){
      print('Its null in display');
      profileImage1=Image.asset('images/defaultProfile.png');
    }

    setState(() {                     //This whole setstate causes the page to load super slow and it apparantly keeps getting
      profileImage=profileImage1;     //called infinitely. so. Take out this setstate, change the ^ profileimage1's to profileimage
      print('in profile page');
      print(profileImage);
    });

  }



  Widget build(BuildContext context) {
    curr= auth.currentUser;
    username=curr.displayName;

    setState(() {
      displayPicture();
      print('now the image is:');
      print(profileImage);
    });

  
    return Scaffold(
      body:Column(
          children: <Widget>[
           Expanded(
             flex: 1,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
                 color: Colors.blueAccent,
               ),
               width: (MediaQuery.of(context).size.width),
               child: SafeArea(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(left: 15.0,top: 20.0,right:15.0),// EdgeInsets.all(15.0),
                           child: Text(
                             "Welcome to Your Profile",
                             style: TextStyle(
                               fontSize: 25.0,
                               fontWeight: FontWeight.bold,
                               color: Colors.white, //blueAccent,
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: BackButton(
                             color: Colors.white,
                             onPressed: (){
                               Navigator.push(context, MaterialPageRoute(
                                 builder: (context) => HomeScreen(curr: curr),
                               )
                               );
                             },
                           ),
                         )
                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               CircleAvatar(

                                 backgroundImage: profileImage.image,//!=null?profileImage.image:Image.asset('images/defaultProfile.png').image,//NetworkImage(userAvatarUrl),
                                 radius: 35,
                               ),
                               SizedBox(
                                 width: 10,
                               ),
                               Text(
                                 '$username',
                                 style: TextStyle(
                                   fontSize: 25.0,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white, //blueAccent,
                                 ),
                               ),
                             ],
                           ),
                           ElevatedButton(
                             onPressed:(){
                               Navigator.push(context, MaterialPageRoute(
                                   builder: (context) => EditProfile(),
                               )
                               );
                               },
                             child: Text(
                               'Edit Profile',
                               style: TextStyle(
                                 color: Colors.blueAccent
                               ),
                             ),
                             style: ButtonStyle(
                               backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                             ),


                           ),

                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),

            Expanded(
              flex:3,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Graphs Depicting Expenditure',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  StreamBuilder(              //STREAM FOR THE LENT CHART
                    stream: FirebaseFirestore.instance.collection('transactions').where('receiver',isEqualTo:  auth.currentUser?.email).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                      }
                      else {
                        int a= snapshot.data.documents.length;
                        for(int i=0; i<a; i++){                               //MAKING THE LIST FOR THE CHART
                          final lent = snapshot.data.documents[i];
                          lentobject l= lentobject(
                            comment: lent.data()['comment'],
                            amt: lent.data()['amount'],
                            barColor: charts.ColorUtil.fromDartColor(Colors.blue)
                          );
                          lentlist.add(l);
                        }
                        return lentchart(                                   // CALLING THE LENT CHART CLASS
                          data: lentlist,
                        );
                      }
                    }
                  ),
                  SizedBox(
                      height: 55.0
                  ),

                  StreamBuilder(                              //STREAM FOR THE OWE CHART
                    stream: FirebaseFirestore.instance
                      .collection('transactions')
                      .where('member', arrayContains: auth.currentUser?.email)
                      .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          ),
                        );
                      }
                      else {
                        int b = snapshot.data.documents.length;
                        for (int i = 0; i < b; i++) {                           //MAKING THE LIST FOR THE CHART
                          final t = snapshot.data.documents[i];
                          Map<dynamic, dynamic> sender = Map.from(t['sender']);
                          Oweobject o = Oweobject(
                              name: t.data()['receiver'],
                              amt: sender[auth.currentUser?.email],
                              barColor: charts.ColorUtil.fromDartColor(Colors.blue)
                          );
                          owelist.add(o);
                        }
                        return owechart(                                        //CALLING OWECHART CLASS
                          data: owelist,
                        );
                      }
                    }
                  ),

                  SizedBox(
                      height: 8.0
                  ),
                ],
                       // ],
                      ),
                    ),
                  ),
          ]
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _fire.out();
          Phoenix.rebirth(context);
        },
        label: Text('Sign Out'),
        //icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.blueAccent,
      ),

      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.blue,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
                color: Colors.blue,
              ),

            ],
          ),
          //child: bottomAppBarContents,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }
}




// Future UpdatePic() async{
//   String fileName = basename(_image.path);
//   StorageReference firebaseStorageRef =
//   FirebaseStorage.instance.ref().child(fileName);
//   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
//   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//   print("Picture updated successfully.");
// }
// import 'charts/Chart_Month/WeekinMonth_class.dart';
// import 'charts/Chart_Month/LineCharts.dart';
// import 'charts/Chart_Month/WeekinMonth_chart.dart';
// import 'charts/Chart_Week/DaysinWeek_chart.dart';
// import 'charts/Chart_Week/DaysinWeek_class.dart';



// if(finish) {
//   setState(() {
//     profileImage = profileImage;
//     finish=false;
//   });
// }