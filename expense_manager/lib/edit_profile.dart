import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_manager/Profile.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'firestorageservice.dart';

String userAvatarUrl='https://www.veterinarypracticenews.com/wp-content/uploads/2019/08/bigstock-Little-Striped-Cute-Kitten-Sit-244080397.jpg';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showSpinner=false;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controller;
  User curr;
  String uid;
  String username;
  File _image;
  Image profileImage;
  final picker = ImagePicker();


  @override
  void initState(){

    //displayPicture();
    this?.ImageFromStorage(context, 'image/img.$uid')?.then((img){
      setState(() {
        profileImage=img;
      });
    });
    if(profileImage==null){
      print('Its null in init');
      profileImage=Image.asset('images/defaultProfile.png');
    }
    super.initState();
  }

  Future getImage() async { //Gets an image
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
        print('picture selected');
      } else {
        print('No image selected.');
      }
    });
  }

  Future ImageFromStorage(BuildContext context, String filePath) async{ //Retrieves the image from where its stored
    Image m;
    String image=filePath;
    await FireStorageService?.loadFromStorage(context, image)?.then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;

  }

  Future uploadPic() async {
    if (_image != null) {
      StorageReference ref = FirebaseStorage.instance.ref();
      StorageTaskSnapshot addImg = await ref
          .child("image/img.$uid")
          .putFile(_image)
          .onComplete;
      if (addImg.error == null) {
        print("added to Firebase Storage");
      }
    }
    setState(() {
      displayPicture();     // Calls the function to retrieve the image
      //soon afetr we store it in firebase storage
    });


  }


  Future displayPicture() async {
    profileImage = await this?.ImageFromStorage(
        context, 'image/img.$uid'); // Calls the function to go to storage
    //And acquire the picture
    print(profileImage);
    print('in edit profile');
  }

  @override
  Widget build(BuildContext context) {
    curr= auth.currentUser;
    uid=curr.uid;
    username=curr.displayName;
    _controller = new TextEditingController(text: '$username');
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: ()async{

                  if(username!=null&& username!='') {
                    setState(() {
                      showSpinner=true;
                    });

                  uploadPic();//-> put it in the getImage function?

                    try {
                      await curr.updateProfile(displayName: username);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(curr: curr),
                          )
                      );
                      setState(() {
                        showSpinner=false;
                      });
                    }
                    catch (e) {
                      Fluttertoast.showToast(
                          msg: e.message,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  }
                  else{
                    Fluttertoast.showToast(
                        msg: "Display name can not be empty",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                },
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),

            ],

          ),

        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  backgroundImage: profileImage!=null?profileImage.image:Image.asset('images/defaultProfile.png').image,//NetworkImage(userAvatarUrl),
                  radius: 45,
                ),
                FlatButton(
                   onPressed:() async {
                     getImage();
                     },
                  child: Text(
                      'Edit Profile Picture'
                  ),
                  //color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    Container(
                      width: 250,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value){
                          //await curr.updateProfile(displayName: value);
                          username=value;
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

      ),
    );

  }
}
// String fileName = basename(_image.path);
// StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
// StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
// StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
// setState(() {
//   print("Profile Picture uploaded");
//   Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
// });